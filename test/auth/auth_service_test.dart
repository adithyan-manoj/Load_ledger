import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/core/auth/auth_models.dart';
import 'package:loan_recovery/core/auth/auth_service.dart';
import 'package:loan_recovery/core/security/secure_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService Tests', () {
    late SecureStorageService secureStorage;
    late Dio testDio;
    late AuthService authService;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      secureStorage = SecureStorageService();
      testDio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000'));
      authService = AuthService(
        secureStorage: secureStorage,
        dio: testDio,
      );
    });

    test('getOrCreateDeviceId persists and reuses device fingerprint', () async {
      final id1 = await authService.getOrCreateDeviceId();
      expect(id1, isNotEmpty);

      final id2 = await authService.getOrCreateDeviceId();
      expect(id2, equals(id1));

      final storedId =
          await secureStorage.read(SecureStorageService.keyDeviceId);
      expect(storedId, equals(id1));
    });

    test('successful login exchanges token and saves credentials', () async {
      testDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/google-login') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'access_token': 'custom_access_jwt_123',
                    'refresh_token': 'custom_refresh_jwt_456',
                    'token_type': 'bearer',
                    'employee': {
                      'id': 'emp-01',
                      'email': 'officer@keralabank.co.in',
                      'name': 'Anand Verma',
                      'role': 'officer',
                      'assigned_branches': ['punalur'],
                      'is_active': true,
                    },
                  },
                ),
              );
            }
            handler.next(options);
          },
        ),
      );

      final result = await authService.signInWithGoogle(
        customIdToken: 'valid_google_token',
        deviceName: 'Test Phone',
      );

      expect(result.employee.email, 'officer@keralabank.co.in');
      expect(result.tokens.accessToken, 'custom_access_jwt_123');

      // Verify stored tokens in secure storage
      expect(
        await secureStorage.read(SecureStorageService.keyAuthToken),
        'custom_access_jwt_123',
      );
      expect(
        await secureStorage.read(SecureStorageService.keyRefreshToken),
        'custom_refresh_jwt_456',
      );

      final cached = await authService.getCachedEmployee();
      expect(cached?.name, 'Anand Verma');
    });

    test('unauthorized employee login throws UnauthorizedEmployeeException', () async {
      testDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/google-login') {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response(
                    requestOptions: options,
                    statusCode: 403,
                    data: {
                      'detail':
                          'Access denied: Email stranger@gmail.com is not authorized by society administration.',
                    },
                  ),
                ),
              );
            }
            handler.next(options);
          },
        ),
      );

      await expectLater(
        authService.signInWithGoogle(
          customIdToken: 'unauthorized_token',
        ),
        throwsA(isA<UnauthorizedEmployeeException>()),
      );
    });

    test('token refresh updates access token in secure storage', () async {
      await secureStorage.write(
        SecureStorageService.keyRefreshToken,
        'old_refresh_token',
      );

      testDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/refresh') {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'access_token': 'new_rotated_access_jwt',
                    'refresh_token': 'new_rotated_refresh_jwt',
                    'token_type': 'bearer',
                  },
                ),
              );
            }
            handler.next(options);
          },
        ),
      );

      final tokens = await authService.refreshToken();
      expect(tokens?.accessToken, 'new_rotated_access_jwt');
      expect(
        await secureStorage.read(SecureStorageService.keyAuthToken),
        'new_rotated_access_jwt',
      );
    });

    test('revoked session on status check wipes credentials and throws DeviceRevokedException', () async {
      await secureStorage.write(
        SecureStorageService.keyAuthToken,
        'revoked_access_jwt',
      );
      await secureStorage.write(
        SecureStorageService.keyRefreshToken,
        'revoked_refresh_jwt',
      );

      testDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/status') {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response(
                    requestOptions: options,
                    statusCode: 401,
                    data: {
                      'detail': 'Device session has been revoked by administration.',
                    },
                  ),
                ),
              );
            }
            handler.next(options);
          },
        ),
      );

      await expectLater(
        authService.checkSessionStatus(),
        throwsA(isA<DeviceRevokedException>()),
      );

      // Verify tokens were wiped
      expect(
        await secureStorage.read(SecureStorageService.keyAuthToken),
        isNull,
      );
      expect(
        await secureStorage.read(SecureStorageService.keyRefreshToken),
        isNull,
      );
    });

    test('signOut wipes tokens and cached profile', () async {
      await secureStorage.write(
        SecureStorageService.keyAuthToken,
        'some_token',
      );
      await secureStorage.write(
        SecureStorageService.keyRefreshToken,
        'some_refresh_token',
      );
      await secureStorage.write(
        AuthService.keyCachedEmployee,
        '{"id":"1","email":"a@b.com","name":"A","role":"officer","assigned_branches":[]}',
      );

      await authService.signOut();

      expect(await authService.getAccessToken(), isNull);
      expect(await authService.getRefreshToken(), isNull);
      expect(await authService.getCachedEmployee(), isNull);
    });
  });
}
