import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service managing hardware-backed secrets (Master encryption key, auth tokens, security flags).
///
/// Uses Keychain on iOS (kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
/// and EncryptedSharedPreferences on Android.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const String keyMasterKey = 'loan_ledger_master_aes_key';
  static const String keyBiometricsEnabled = 'loan_ledger_biometrics_enabled';
  static const String keyAuthToken = 'loan_ledger_auth_jwt';
  static const String keyRefreshToken = 'loan_ledger_refresh_jwt';
  static const String keyDeviceId = 'loan_ledger_device_id';

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(resetOnError: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.unlocked_this_device,
              ),
            );

  /// Retrieves the 256-bit AES master encryption key, or generates and securely stores
  /// a new random key if this is the first execution.
  Future<String> getOrCreateMasterKey() async {
    final existing = await _storage.read(key: keyMasterKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final newKey = _generateSecure256BitKey();
    await _storage.write(key: keyMasterKey, value: newKey);
    return newKey;
  }

  /// Generates a cryptographically secure 256-bit (32 bytes) random base64 string.
  static String _generateSecure256BitKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64UrlEncode(values);
  }

  // --- Generic Storage Accessors ---

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<bool> containsKey(String key) => _storage.containsKey(key: key);

  Future<void> clearAll() => _storage.deleteAll();

  // --- Convenience Getters / Setters ---

  Future<bool> isBiometricsEnabled() async {
    final val = await _storage.read(key: keyBiometricsEnabled);
    return val != 'false'; // Enabled by default
  }

  Future<void> setBiometricsEnabled(bool enabled) =>
      _storage.write(key: keyBiometricsEnabled, value: enabled.toString());
}
