import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/core/auth/auth_models.dart';
import 'package:loan_recovery/core/auth/auth_providers.dart';
import 'package:loan_recovery/screens/auth/login_screen.dart';

void main() {
  Widget createTestWidget({AuthState? initialState}) {
    return ProviderScope(
      overrides: [
        if (initialState != null)
          authNotifierProvider.overrideWith(() => _MockAuthNotifier(initialState)),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders bank header and Sign in with Google button', (tester) async {
      await tester.pumpWidget(createTestWidget(
        initialState: AuthState.unauthenticated(),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Kerala Co-operative Bank'), findsOneWidget);
      expect(find.text('Loan Ledger & Recovery'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('displays error banner when employee is unauthorized', (tester) async {
      await tester.pumpWidget(createTestWidget(
        initialState: AuthState.error(
          'Access denied: stranger@gmail.com is not on the employee roster.',
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Authorization Denied'), findsOneWidget);
      expect(
        find.textContaining('stranger@gmail.com is not on the employee roster'),
        findsOneWidget,
      );
    });

    testWidgets('displays revocation banner when device is blacklisted', (tester) async {
      await tester.pumpWidget(createTestWidget(
        initialState: AuthState.revoked(
          'This device was remotely deactivated by administration.',
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Device Access Blacklisted'), findsOneWidget);
      expect(
        find.textContaining('remotely deactivated by administration'),
        findsOneWidget,
      );
    });

    testWidgets('displays loading spinner when authenticating', (tester) async {
      await tester.pumpWidget(createTestWidget(
        initialState: AuthState.authenticating(),
      ));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

class _MockAuthNotifier extends AuthNotifier {
  final AuthState _initial;
  _MockAuthNotifier(this._initial);

  @override
  AuthState build() => _initial;
}

