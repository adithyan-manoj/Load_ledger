import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import '../config/api_config.dart';
import '../security/secure_storage_service.dart';
import 'auth_models.dart';

/// Service responsible for Google authentication, token lifecycle management,
/// and identity verification with the FastAPI backend.
class AuthService {
  final Dio _dio;
  final SecureStorageService _secureStorage;
  final GoogleSignIn? _googleSignIn;

  static const String keyCachedEmployee = 'loan_ledger_cached_employee';

  AuthService({
    required SecureStorageService secureStorage,
    Dio? dio,
    GoogleSignIn? googleSignIn,
    String? baseUrl,
  })  : _secureStorage = secureStorage,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? ApiConfig.defaultBaseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {'Content-Type': 'application/json'},
              ),
            ),
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: [
                'email',
                'https://www.googleapis.com/auth/userinfo.profile',
              ],
            );

  /// Retrieves the unique hardware device fingerprint or generates and stores one.
  Future<String> getOrCreateDeviceId() async {
    final existingId =
        await _secureStorage.read(SecureStorageService.keyDeviceId);
    if (existingId != null && existingId.isNotEmpty) {
      return existingId;
    }
    final newId = const Uuid().v4();
    await _secureStorage.write(SecureStorageService.keyDeviceId, newId);
    return newId;
  }

  /// Initiates Google Sign-In, retrieves the ID token, and exchanges it for a
  /// custom backend JWT pair while validating employee authorization.
  ///
  /// Passing [customIdToken] allows testing or simulating tokens directly.
  Future<AuthResult> signInWithGoogle({
    String? customIdToken,
    String deviceName = 'Mobile Device',
  }) async {
    String? idToken = customIdToken;

    if (idToken == null) {
      if (_googleSignIn == null) {
        throw const AuthException('Google Sign-In is not initialized.');
      }

      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw const GoogleSignInCanceledException();
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      idToken = auth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw const AuthException(
          'Failed to retrieve Google ID token from authentication provider.',
        );
      }
    }

    final deviceId = await getOrCreateDeviceId();

    try {
      final response = await _dio.post(
        '/auth/google-login',
        data: {
          'id_token': idToken,
          'device_id': deviceId,
          'device_name': deviceName,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final tokens = AuthTokens.fromJson(data);
      final employee =
          AuthEmployee.fromJson(data['employee'] as Map<String, dynamic>);

      // Persist session tokens and employee data
      await _secureStorage.write(
        SecureStorageService.keyAuthToken,
        tokens.accessToken,
      );
      await _secureStorage.write(
        SecureStorageService.keyRefreshToken,
        tokens.refreshToken,
      );
      await _secureStorage.write(
        keyCachedEmployee,
        jsonEncode(employee.toJson()),
      );

      return AuthResult(employee: employee, tokens: tokens);
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Uses the stored refresh token to obtain a fresh access token.
  Future<AuthTokens?> refreshToken() async {
    final storedRefreshToken =
        await _secureStorage.read(SecureStorageService.keyRefreshToken);
    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      return null;
    }

    final deviceId = await getOrCreateDeviceId();

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {
          'refresh_token': storedRefreshToken,
          'device_id': deviceId,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final newTokens = AuthTokens.fromJson(data);

      await _secureStorage.write(
        SecureStorageService.keyAuthToken,
        newTokens.accessToken,
      );
      await _secureStorage.write(
        SecureStorageService.keyRefreshToken,
        newTokens.refreshToken,
      );

      if (data['employee'] != null) {
        final employee =
            AuthEmployee.fromJson(data['employee'] as Map<String, dynamic>);
        await _secureStorage.write(
          keyCachedEmployee,
          jsonEncode(employee.toJson()),
        );
      }

      return newTokens;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        final detail = _extractDetail(e.response?.data);
        await clearAuthSession();
        if (detail.toLowerCase().contains('revoked')) {
          throw DeviceRevokedException(detail);
        }
        throw AuthException(detail, statusCode: e.response?.statusCode);
      }
      _handleDioError(e);
      return null;
    }
  }

  /// Checks the current session status with the identity server.
  /// Detects remote revocation or authorization changes.
  Future<AuthEmployee?> checkSessionStatus() async {
    final accessToken =
        await _secureStorage.read(SecureStorageService.keyAuthToken);
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    try {
      final response = await _dio.get(
        '/auth/status',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final employee =
          AuthEmployee.fromJson(data['employee'] as Map<String, dynamic>);

      await _secureStorage.write(
        keyCachedEmployee,
        jsonEncode(employee.toJson()),
      );

      return employee;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final detail = _extractDetail(e.response?.data);
        if (detail.toLowerCase().contains('revoked') ||
            detail.toLowerCase().contains('disabled')) {
          await clearAuthSession();
          throw DeviceRevokedException(detail);
        }

        // Try refreshing access token
        final newTokens = await refreshToken();
        if (newTokens != null) {
          return checkSessionStatus();
        }
      }
      _handleDioError(e);
      return null;
    }
  }

  /// Retrieves the cached employee data from secure storage.
  Future<AuthEmployee?> getCachedEmployee() async {
    final raw = await _secureStorage.read(keyCachedEmployee);
    if (raw == null || raw.isEmpty) return null;
    try {
      return AuthEmployee.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Retrieves stored access token.
  Future<String?> getAccessToken() =>
      _secureStorage.read(SecureStorageService.keyAuthToken);

  /// Retrieves stored refresh token.
  Future<String?> getRefreshToken() =>
      _secureStorage.read(SecureStorageService.keyRefreshToken);

  /// Clears stored authentication session tokens and cached profile.
  Future<void> clearAuthSession() async {
    await _secureStorage.delete(SecureStorageService.keyAuthToken);
    await _secureStorage.delete(SecureStorageService.keyRefreshToken);
    await _secureStorage.delete(keyCachedEmployee);
  }

  /// Signs the user out from Google and wipes session tokens.
  Future<void> signOut() async {
    try {
      if (_googleSignIn != null && await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (_) {}
    await clearAuthSession();
  }

  void _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final detail = _extractDetail(e.response?.data);

    if (statusCode == 403) {
      throw UnauthorizedEmployeeException(
        detail.isNotEmpty
            ? detail
            : 'Access denied: Google account is not on the authorized employee roster.',
      );
    } else if (statusCode == 401) {
      if (detail.toLowerCase().contains('revoked')) {
        throw DeviceRevokedException(detail);
      }
      throw AuthException(
        detail.isNotEmpty ? detail : 'Authentication failed.',
        statusCode: 401,
      );
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const AuthException(
        'Unable to connect to the authentication server. Please check your network connection.',
      );
    } else {
      throw AuthException(
        detail.isNotEmpty ? detail : (e.message ?? 'Unknown authentication error occurred.'),
        statusCode: statusCode,
      );
    }
  }

  String _extractDetail(dynamic data) {
    if (data == null) return '';
    if (data is Map && data['detail'] != null) {
      return data['detail'].toString();
    }
    if (data is String) return data;
    return '';
  }
}

