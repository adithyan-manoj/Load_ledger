import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/core/security/secure_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureStorageService Tests', () {
    late SecureStorageService secureStorage;

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      secureStorage = SecureStorageService();
    });

    test('generates and persists 256-bit AES master key on first access', () async {
      final key1 = await secureStorage.getOrCreateMasterKey();
      expect(key1, isNotEmpty);
      expect(key1.length, greaterThanOrEqualTo(32));

      // Second retrieval must return the exact same key
      final key2 = await secureStorage.getOrCreateMasterKey();
      expect(key2, equals(key1));
    });

    test('stores and toggles biometric preference flags', () async {
      // By default biometrics should be enabled
      expect(await secureStorage.isBiometricsEnabled(), isTrue);

      await secureStorage.setBiometricsEnabled(false);
      expect(await secureStorage.isBiometricsEnabled(), isFalse);

      await secureStorage.setBiometricsEnabled(true);
      expect(await secureStorage.isBiometricsEnabled(), isTrue);
    });

    test('supports writing, reading, and clearing custom keys', () async {
      await secureStorage.write('custom_jwt', 'sample.jwt.token');
      expect(await secureStorage.read('custom_jwt'), 'sample.jwt.token');

      await secureStorage.delete('custom_jwt');
      expect(await secureStorage.read('custom_jwt'), isNull);
    });
  });
}

