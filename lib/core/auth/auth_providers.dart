import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../security/security_providers.dart';
import 'auth_models.dart';
import 'auth_service.dart';

/// Provider for AuthService.
final authServiceProvider = Provider<AuthService>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return AuthService(secureStorage: secureStorage);
});

/// Riverpod 3 Notifier managing reactive Authentication State.
class AuthNotifier extends Notifier<AuthState> {
  /// When true, bypasses the Google login screen and initializes with a local authorized officer.
  /// Biometric / PIN physical device authentication remains 100% active on cold launch & resume.
  static const bool bypassGoogleAuth = true;

  static const defaultLocalOfficer = AuthEmployee(
    id: 'local-admin-01',
    email: 'officer@keralabank.co.in',
    name: 'Postal Recovery Officer',
    role: 'admin',
    assignedBranches: ['punalur', 'adoor', 'kollam', 'alappuzha'],
    isActive: true,
  );

  @override
  AuthState build() {
    if (bypassGoogleAuth) {
      return AuthState.authenticated(defaultLocalOfficer);
    }
    // Automatically trigger background session validation on startup
    Future.microtask(() => checkExistingSession());
    return AuthState.initial();
  }

  AuthService get _authService => ref.read(authServiceProvider);

  /// Checks local secure storage and attempts verification with the identity server.
  Future<void> checkExistingSession() async {
    try {
      final token = await _authService.getAccessToken();
      if (token == null || token.isEmpty) {
        state = AuthState.unauthenticated();
        return;
      }

      final cachedEmployee = await _authService.getCachedEmployee();
      if (cachedEmployee != null) {
        // Fast local-first launch with cached credentials
        state = AuthState.authenticated(cachedEmployee);
      }

      // Verify active session with identity server in background
      try {
        final verifiedEmployee = await _authService.checkSessionStatus();
        if (verifiedEmployee != null) {
          state = AuthState.authenticated(verifiedEmployee);
        } else if (cachedEmployee == null) {
          state = AuthState.unauthenticated();
        }
      } on DeviceRevokedException catch (e) {
        state = AuthState.revoked(e.message);
      } catch (_) {
        // In local-first architecture, if network is down but token existed,
        // preserve the authenticated state if we had a cached employee.
        if (cachedEmployee == null) {
          state = AuthState.unauthenticated();
        }
      }
    } catch (e) {
      state = AuthState.unauthenticated();
    }
  }

  /// Initiates Google Sign-In with backend whitelist verification.
  Future<void> signInWithGoogle({
    String? customIdToken,
    String deviceName = 'Mobile Device',
  }) async {
    state = state.copyWith(
      status: AuthStatus.authenticating,
      errorMessage: null,
    );

    try {
      final result = await _authService.signInWithGoogle(
        customIdToken: customIdToken,
        deviceName: deviceName,
      );
      state = AuthState.authenticated(result.employee);
    } on GoogleSignInCanceledException {
      state = AuthState.unauthenticated();
    } on UnauthorizedEmployeeException catch (e) {
      state = AuthState.error(e.message);
    } on DeviceRevokedException catch (e) {
      state = AuthState.revoked(e.message);
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error('An unexpected error occurred during login: $e');
    }
  }

  /// Signs out from Google and clears session credentials.
  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.authenticating);
    try {
      await _authService.signOut();
    } finally {
      state = AuthState.unauthenticated();
    }
  }

  /// Manually transitions state to revoked when remote kill-switch fires.
  void setRevoked(String message) {
    state = AuthState.revoked(message);
  }

  /// Clears any transient error message.
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: null,
      );
    }
  }
}

/// Global provider for Auth state management.
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

