import 'package:dio/dio.dart';
import '../core/auth/auth_models.dart';
import '../core/auth/auth_service.dart';

/// Dio QueuedInterceptor that attaches JWT bearer tokens to outbound requests
/// and seamlessly handles token refreshing and remote revocation.
class AuthInterceptor extends QueuedInterceptor {
  final AuthService _authService;
  final Dio _dio;
  final void Function(String message)? onRevoked;
  final void Function()? onUnauthenticated;

  AuthInterceptor({
    required AuthService authService,
    required Dio dio,
    this.onRevoked,
    this.onUnauthenticated,
  })  : _authService = authService,
        _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip injecting auth headers for public auth endpoints
    if (options.path.contains('/auth/google-login') ||
        options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final token = await _authService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;

    // Check if error is 401 Unauthorized
    if (response?.statusCode == 401) {
      final detail = _extractDetail(response?.data);

      // Check if session has been explicitly revoked by remote administrator
      if (detail.toLowerCase().contains('revoked') ||
          detail.toLowerCase().contains('disabled')) {
        onRevoked?.call(detail);
        return handler.reject(err);
      }

      // If this was an auth endpoint failing, don't attempt to refresh
      if (err.requestOptions.path.contains('/auth/')) {
        return handler.reject(err);
      }

      try {
        // Attempt token rotation using refresh token
        final newTokens = await _authService.refreshToken();
        if (newTokens != null) {
          // Retry original request with newly acquired access token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';

          final cloneReq = await _dio.fetch(options);
          return handler.resolve(cloneReq);
        } else {
          onUnauthenticated?.call();
          return handler.reject(err);
        }
      } on DeviceRevokedException catch (e) {
        onRevoked?.call(e.message);
        return handler.reject(err);
      } catch (_) {
        onUnauthenticated?.call();
        return handler.reject(err);
      }
    }

    return handler.next(err);
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

