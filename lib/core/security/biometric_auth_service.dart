import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricStatus {
  success,
  failed,
  notAvailable,
  notEnrolled,
  lockedOut,
  error,
}

class BiometricResult {
  final bool isAuthenticated;
  final BiometricStatus status;
  final String? errorMessage;

  const BiometricResult({
    required this.isAuthenticated,
    required this.status,
    this.errorMessage,
  });

  factory BiometricResult.success() => const BiometricResult(
        isAuthenticated: true,
        status: BiometricStatus.success,
      );

  factory BiometricResult.failure(BiometricStatus status, [String? message]) =>
      BiometricResult(
        isAuthenticated: false,
        status: status,
        errorMessage: message,
      );
}

/// Service managing device biometric & PIN authentication.
class BiometricAuthService {
  final LocalAuthentication _auth;

  BiometricAuthService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  /// Checks whether hardware biometrics or device passcodes are supported on this device.
  Future<bool> canAuthenticate() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Lists available biometric hardware types (fingerprint, face, iris, etc.).
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return [];
    }
  }

  /// Prompts the user with the native FaceID / TouchID / Device PIN sheet.
  Future<BiometricResult> authenticate({
    String localizedReason =
        'Authenticate to access the Co-operative Loan Recovery System',
  }) async {
    try {
      final available = await canAuthenticate();
      if (!available) {
        return BiometricResult.failure(
          BiometricStatus.notAvailable,
          'Biometrics or device security not available on this device.',
        );
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: false, // Allows device PIN fallback if biometric fails
        persistAcrossBackgrounding: true,
      );

      if (didAuthenticate) {
        return BiometricResult.success();
      } else {
        return BiometricResult.failure(
          BiometricStatus.failed,
          'User cancelled or failed authentication.',
        );
      }
    } on LocalAuthException catch (e) {
      switch (e.code) {
        case LocalAuthExceptionCode.noBiometricHardware:
          return BiometricResult.failure(
              BiometricStatus.notAvailable, e.description);
        case LocalAuthExceptionCode.noBiometricsEnrolled:
          return BiometricResult.failure(
              BiometricStatus.notEnrolled, e.description);
        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.biometricLockout:
          return BiometricResult.failure(
              BiometricStatus.lockedOut, e.description);
        default:
          return BiometricResult.failure(
              BiometricStatus.error, e.description);
      }
    } on PlatformException catch (e) {
      return BiometricResult.failure(BiometricStatus.error, e.message);
    } catch (e) {
      return BiometricResult.failure(BiometricStatus.error, e.toString());
    }
  }
}
