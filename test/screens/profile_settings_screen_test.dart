import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/core/auth/auth_models.dart';
import 'package:loan_recovery/core/auth/auth_providers.dart';
import 'package:loan_recovery/screens/profile_settings_screen.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  testWidgets('ProfileSettingsScreen renders all 5 fintech sections and officer profile',
      (WidgetTester tester) async {
    final mockEmployee = AuthEmployee(
      id: 'emp-uuid-12345',
      email: 'officer@keralabank.co.in',
      name: 'Adithyan Manoj',
      role: 'officer',
      assignedBranches: ['Cherthala', 'Alappuzha'],
      isActive: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(
            () => _MockAuthNotifier(mockEmployee),
          ),
        ],
        child: const MaterialApp(
          home: ProfileSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('Officer Profile & System'), findsOneWidget);

    // Verify 5 Sections
    expect(find.text('OFFICER IDENTITY'), findsOneWidget);
    expect(find.text('HARDWARE ENCLAVE & SECURITY'), findsOneWidget);
    expect(find.text('CLOUD & DISASTER RECOVERY'), findsOneWidget);
    expect(find.text('DATABASE MAINTENANCE'), findsOneWidget);
    expect(find.text('SESSION TERMINATION'), findsOneWidget);

    // Verify Officer Identity Details
    expect(find.text('Adithyan Manoj'), findsOneWidget);
    expect(find.text('officer@keralabank.co.in'), findsOneWidget);
    expect(find.text('ROLE: OFFICER'), findsOneWidget);
    expect(find.text('SESSION ACTIVE'), findsOneWidget);
    expect(find.text('Cherthala, Alappuzha'), findsOneWidget);

    // Verify Buttons
    expect(find.text('LOCK SESSION NOW'), findsOneWidget);
    expect(find.text('CREATE ENCRYPTED BACKUP NOW'), findsOneWidget);
    expect(find.text('IMPORT / UPDATE PDF DATA'), findsOneWidget);
    expect(find.text('CLEAR LOCAL DATABASE'), findsOneWidget);
    expect(find.text('SIGN OUT OF OFFICER SESSION'), findsOneWidget);
  });
}

class _MockAuthNotifier extends AuthNotifier {
  final AuthEmployee _emp;
  _MockAuthNotifier(this._emp);

  @override
  AuthState build() {
    return AuthState(
      status: AuthStatus.authenticated,
      employee: _emp,
    );
  }
}

