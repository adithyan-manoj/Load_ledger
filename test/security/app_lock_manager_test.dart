import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/core/security/biometric_auth_service.dart';
import 'package:loan_recovery/core/security/secure_storage_service.dart';
import 'package:loan_recovery/core/security/security_providers.dart';

class FakeBiometricAuthService extends BiometricAuthService {
  bool shouldSucceed;
  FakeBiometricAuthService({this.shouldSucceed = true});

  @override
  Future<bool> canAuthenticate() async => true;

  @override
  Future<BiometricResult> authenticate({
    String localizedReason = '',
  }) async {
    if (shouldSucceed) {
      return BiometricResult.success();
    }
    return BiometricResult.failure(
        BiometricStatus.failed, 'Authentication rejected');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLockNotifier Tests', () {
    late SecureStorageService secureStorage;
    late FakeBiometricAuthService biometrics;
    late ProviderContainer container;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      secureStorage = SecureStorageService();
      biometrics = FakeBiometricAuthService(shouldSucceed: true);

      container = ProviderContainer(
        overrides: [
          secureStorageServiceProvider.overrideWithValue(secureStorage),
          biometricAuthServiceProvider.overrideWithValue(biometrics),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('starts in locked state on cold launch', () {
      expect(container.read(appLockProvider), isTrue);
    });

    test('manual unlock and lock transitions state correctly', () {
      container.read(appLockProvider.notifier).unlock();
      expect(container.read(appLockProvider), isFalse);

      container.read(appLockProvider.notifier).lock();
      expect(container.read(appLockProvider), isTrue);
    });

    test('authenticateAndUnlock unlocks state when biometric succeeds', () async {
      biometrics.shouldSucceed = true;
      final result =
          await container.read(appLockProvider.notifier).authenticateAndUnlock();

      expect(result.isAuthenticated, isTrue);
      expect(container.read(appLockProvider), isFalse);
    });

    test('authenticateAndUnlock preserves lock state when biometric fails', () async {
      biometrics.shouldSucceed = false;
      final result =
          await container.read(appLockProvider.notifier).authenticateAndUnlock();

      expect(result.isAuthenticated, isFalse);
      expect(container.read(appLockProvider), isTrue);
    });

    test('unlocks without biometric check if biometrics are disabled by user', () async {
      await secureStorage.setBiometricsEnabled(false);
      biometrics.shouldSucceed = false;

      final result =
          await container.read(appLockProvider.notifier).authenticateAndUnlock();
      expect(result.isAuthenticated, isTrue);
      expect(container.read(appLockProvider), isFalse);
    });
  });
}
