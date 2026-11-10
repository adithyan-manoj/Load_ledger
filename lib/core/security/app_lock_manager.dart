import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'biometric_auth_service.dart';
import 'security_providers.dart';

/// Notifier managing app lock state (locked/unlocked).
class AppLockNotifier extends Notifier<bool> with WidgetsBindingObserver {
  DateTime? _pausedAt;
  Duration gracePeriod = const Duration(seconds: 15);

  @override
  bool build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });
    return true; // Start locked on cold launch
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      if (_pausedAt != null) {
        final elapsed = DateTime.now().difference(_pausedAt!);
        if (elapsed > gracePeriod) {
          lock();
        }
        _pausedAt = null;
      }
    }
  }

  /// Manually locks the application.
  void lock() {
    state = true;
  }

  /// Manually unlocks the application (e.g. after successful auth).
  void unlock() {
    state = false;
  }

  /// Attempts biometric/PIN authentication and unlocks if successful.
  Future<BiometricResult> authenticateAndUnlock() async {
    final secureStorage = ref.read(secureStorageServiceProvider);
    final biometrics = ref.read(biometricAuthServiceProvider);

    final enabled = await secureStorage.isBiometricsEnabled();
    if (!enabled) {
      unlock();
      return BiometricResult.success();
    }

    final result = await biometrics.authenticate();
    if (result.isAuthenticated) {
      unlock();
    }
    return result;
  }
}
