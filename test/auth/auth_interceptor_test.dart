import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/core/auth/auth_service.dart';
import 'package:loan_recovery/core/security/secure_storage_service.dart';
import 'package:loan_recovery/data/auth_interceptor.dart';

class _MockRequestHandler extends RequestInterceptorHandler {
  RequestOptions? options;
  @override
  void next(RequestOptions options) {
    this.options = options;
  }
}

class _MockErrorHandler extends ErrorInterceptorHandler {
  DioException? rejectedError;
  Response? resolvedResponse;

  @override
  void reject(DioException error) {
    rejectedError = error;
  }

  @override
  void resolve(Response response) {
    resolvedResponse = response;
  }

  @override
  void next(DioException err) {
    rejectedError = err;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthInterceptor Tests', () {
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

    test('injects Bearer token into outgoing non-auth requests', () async {
      await secureStorage.write(
        SecureStorageService.keyAuthToken,
        'my_test_bearer_token',
      );

      final interceptor = AuthInterceptor(
        authService: authService,
        dio: testDio,
      );

      final handler = _MockRequestHandler();
      final options = RequestOptions(path: '/customers/');

      await interceptor.onRequest(options, handler);

      expect(handler.options?.headers['Authorization'],
          'Bearer my_test_bearer_token');
    });

    test('does not inject token into /auth/ endpoints', () async {
      await secureStorage.write(
        SecureStorageService.keyAuthToken,
        'my_test_bearer_token',
      );

      final interceptor = AuthInterceptor(
        authService: authService,
        dio: testDio,
      );

      final handler = _MockRequestHandler();
      final options = RequestOptions(path: '/auth/google-login');

      await interceptor.onRequest(options, handler);

      expect(handler.options?.headers['Authorization'], isNull);
    });

    test('triggers onRevoked callback when 401 response contains revoked detail',
        () async {
      bool revokedCallbackTriggered = false;

      final interceptor = AuthInterceptor(
        authService: authService,
        dio: testDio,
        onRevoked: (msg) {
          revokedCallbackTriggered = true;
        },
      );

      final handler = _MockErrorHandler();
      final exception = DioException(
        requestOptions: RequestOptions(path: '/branches/'),
        response: Response(
          requestOptions: RequestOptions(path: '/branches/'),
          statusCode: 401,
          data: {'detail': 'Device session has been revoked by admin'},
        ),
      );

      await interceptor.onError(exception, handler);

      expect(revokedCallbackTriggered, isTrue);
      expect(handler.rejectedError, isNotNull);
    });

    test('triggers onUnauthenticated callback when refresh fails on 401',
        () async {
      bool unauthenticatedCallbackTriggered = false;

      final interceptor = AuthInterceptor(
        authService: authService,
        dio: testDio,
        onUnauthenticated: () {
          unauthenticatedCallbackTriggered = true;
        },
      );

      final handler = _MockErrorHandler();
      final exception = DioException(
        requestOptions: RequestOptions(path: '/branches/'),
        response: Response(
          requestOptions: RequestOptions(path: '/branches/'),
          statusCode: 401,
          data: {'detail': 'Token expired'},
        ),
      );

      await interceptor.onError(exception, handler);

      expect(unauthenticatedCallbackTriggered, isTrue);
    });
  });
}
