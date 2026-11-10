import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/core/auth/auth_models.dart';

void main() {
  group('AuthEmployee Tests', () {
    test('parses employee json with list branches correctly', () {
      final json = {
        'id': 'emp-101',
        'email': 'officer@keralabank.co.in',
        'name': 'Suresh Kumar',
        'role': 'officer',
        'assigned_branches': ['punalur', 'adoor'],
        'is_active': true,
      };

      final emp = AuthEmployee.fromJson(json);
      expect(emp.id, 'emp-101');
      expect(emp.email, 'officer@keralabank.co.in');
      expect(emp.name, 'Suresh Kumar');
      expect(emp.role, 'officer');
      expect(emp.isOfficer, isTrue);
      expect(emp.isAdmin, isFalse);
      expect(emp.isAuditor, isFalse);
      expect(emp.assignedBranches, ['punalur', 'adoor']);
      expect(emp.canAccessBranch('punalur'), isTrue);
      expect(emp.canAccessBranch('kollam'), isFalse);
    });

    test('parses employee json with stringified branches correctly', () {
      final json = {
        'id': 'emp-102',
        'email': 'admin@keralabank.co.in',
        'name': 'Chief Executive',
        'role': 'admin',
        'assigned_branches': '["punalur", "adoor", "kollam"]',
        'is_active': true,
      };

      final emp = AuthEmployee.fromJson(json);
      expect(emp.isAdmin, isTrue);
      expect(emp.canAccessBranch('any_branch'), isTrue);
    });

    test('auditor has access across all branches', () {
      final emp = AuthEmployee(
        id: 'auditor-1',
        email: 'auditor@keralabank.co.in',
        name: 'Internal Auditor',
        role: 'auditor',
        assignedBranches: ['punalur'],
      );

      expect(emp.isAuditor, isTrue);
      expect(emp.canAccessBranch('adoor'), isTrue);
    });
  });

  group('AuthTokens and AuthState Tests', () {
    test('serializes and deserializes AuthTokens', () {
      final tokens = const AuthTokens(
        accessToken: 'access.jwt.test',
        refreshToken: 'refresh.jwt.test',
      );

      final json = tokens.toJson();
      final reconstructed = AuthTokens.fromJson(json);
      expect(reconstructed.accessToken, 'access.jwt.test');
      expect(reconstructed.refreshToken, 'refresh.jwt.test');
      expect(reconstructed.tokenType, 'bearer');
    });

    test('validates AuthState states and flags', () {
      final initial = AuthState.initial();
      expect(initial.status, AuthStatus.initial);
      expect(initial.isAuthenticated, isFalse);

      final employee = const AuthEmployee(
        id: '1',
        email: 'test@keralabank.co.in',
        name: 'Test Officer',
      );

      final auth = AuthState.authenticated(employee);
      expect(auth.isAuthenticated, isTrue);
      expect(auth.employee?.email, 'test@keralabank.co.in');

      final revoked = AuthState.revoked('Device stolen');
      expect(revoked.isRevoked, isTrue);
      expect(revoked.errorMessage, 'Device stolen');

      final err = AuthState.error('Network timeout');
      expect(err.hasError, isTrue);
      expect(err.errorMessage, 'Network timeout');
    });
  });
}

