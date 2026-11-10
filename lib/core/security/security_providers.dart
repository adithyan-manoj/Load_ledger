import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'secure_storage_service.dart';
import 'cipher_service.dart';
import 'biometric_auth_service.dart';
import 'app_lock_manager.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthService();
});

/// Asynchronously loads or initializes the 256-bit AES master encryption key and returns CipherService.
final cipherServiceProvider = FutureProvider<CipherService>((ref) async {
  final storage = ref.watch(secureStorageServiceProvider);
  final masterKey = await storage.getOrCreateMasterKey();
  return CipherService(base64Key: masterKey);
});

/// Global App Lock State Provider (Riverpod 3 NotifierProvider).
final appLockProvider =
    NotifierProvider<AppLockNotifier, bool>(AppLockNotifier.new);
