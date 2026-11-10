import 'dart:convert';

/// Represents an employee authorized to access the system.
class AuthEmployee {
  final String id;
  final String email;
  final String name;
  final String role; // 'officer', 'auditor', 'admin'
  final List<String> assignedBranches;
  final bool isActive;

  const AuthEmployee({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'officer',
    this.assignedBranches = const [],
    this.isActive = true,
  });

  bool get isAdmin => role == 'admin';
  bool get isAuditor => role == 'auditor';
  bool get isOfficer => role == 'officer';

  bool canAccessBranch(String branchSlug) {
    if (isAdmin || isAuditor) return true;
    if (assignedBranches.isEmpty) return true; // Unrestricted if not specified
    return assignedBranches.contains(branchSlug);
  }

  factory AuthEmployee.fromJson(Map<String, dynamic> json) {
    List<String> branches = [];
    if (json['assigned_branches'] != null) {
      if (json['assigned_branches'] is List) {
        branches = (json['assigned_branches'] as List)
            .map((e) => e.toString())
            .toList();
      } else if (json['assigned_branches'] is String) {
        try {
          final decoded = jsonDecode(json['assigned_branches'] as String);
          if (decoded is List) {
            branches = decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
      }
    }

    return AuthEmployee(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'officer',
      assignedBranches: branches,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'role': role,
        'assigned_branches': assignedBranches,
        'is_active': isActive,
      };

  @override
  String toString() => 'AuthEmployee(email: $email, name: $name, role: $role)';
}

/// Token bundle returned by the identity gateway.
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'bearer',
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'token_type': tokenType,
      };
}

/// Result of an authentication request.
class AuthResult {
  final AuthEmployee employee;
  final AuthTokens tokens;

  const AuthResult({
    required this.employee,
    required this.tokens,
  });
}

/// Current status of the user's authentication state.
enum AuthStatus {
  initial,
  unauthenticated,
  authenticating,
  authenticated,
  revoked,
  error,
}

/// Immutable state holder for authentication.
class AuthState {
  final AuthStatus status;
  final AuthEmployee? employee;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.employee,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.unauthenticated([String? error]) => AuthState(
        status: AuthStatus.unauthenticated,
        errorMessage: error,
      );

  factory AuthState.authenticating() => const AuthState(
        status: AuthStatus.authenticating,
      );

  factory AuthState.authenticated(AuthEmployee employee) => AuthState(
        status: AuthStatus.authenticated,
        employee: employee,
      );

  factory AuthState.revoked([String? message]) => AuthState(
        status: AuthStatus.revoked,
        errorMessage: message ?? 'Device access has been revoked by administration.',
      );

  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isAuthenticating => status == AuthStatus.authenticating;
  bool get isRevoked => status == AuthStatus.revoked;
  bool get hasError => status == AuthStatus.error;

  AuthState copyWith({
    AuthStatus? status,
    AuthEmployee? employee,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      employee: employee ?? this.employee,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'AuthState(status: $status, employee: ${employee?.email}, error: $errorMessage)';
}

/// Authentication Exceptions
class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Specific exception when the Google account is not on the employee whitelist.
class UnauthorizedEmployeeException extends AuthException {
  const UnauthorizedEmployeeException(super.message)
      : super(statusCode: 403);
}

/// Specific exception when the device session or account has been revoked.
class DeviceRevokedException extends AuthException {
  const DeviceRevokedException(super.message)
      : super(statusCode: 401);
}

/// Specific exception when the user cancels the Google Sign-In prompt.
class GoogleSignInCanceledException extends AuthException {
  const GoogleSignInCanceledException()
      : super('Google sign-in was canceled by the user.');
}
