import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/data/data_providers.dart';
import 'package:loan_recovery/domain/models/customer.dart';
import 'package:loan_recovery/domain/models/loan.dart';
import 'package:loan_recovery/domain/models/office.dart';
import 'package:loan_recovery/screens/branch_details_screen.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  testWidgets(
      'BranchDetailsScreen renders KPI ticker, filter bar, and inline accordion expansion',
      (WidgetTester tester) async {
    const testBranchId = 'branch-101';
    final testOffice = Office(id: testBranchId, branchId: 'B-01', name: 'Alappuzha Main Unit');
    final testCustomer = Customer(
      id: 'cust-1',
      officeId: testBranchId,
      name: 'Radhakrishnan Nair',
      memberNo: 'M-502',
    );
    final testLoan = Loan(
      id: 'loan-1',
      customerId: 'cust-1',
      accountNo: 'LN-7749',
      principalOutstanding: 35000.0,
      baseEmiAmount: 2200.0,
      status: 'Active',
    );

    final mockAppState = AppState(
      offices: [testOffice],
      customers: [testCustomer],
      loans: [testLoan],
      monthlyRecoveries: [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appStateProvider.overrideWith(
            () => _MockAppStateNotifier(mockAppState),
          ),
        ],
        child: const MaterialApp(
          home: BranchDetailsScreen(branchId: testBranchId),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Top Ticker
    expect(find.text('Alappuzha Main Unit'), findsOneWidget);
    expect(find.text('GROSS PRINCIPAL'), findsOneWidget);
    expect(find.text('ACTIVE LOANS'), findsOneWidget);
    expect(find.text('₹35,000'), findsWidgets);

    // Verify Filter Pill Bar
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Overdue'), findsOneWidget);

    // Verify Member Row (Collapsed state)
    expect(find.text('Radhakrishnan Nair'), findsOneWidget);
    expect(find.text('MEMBER #M-502'), findsOneWidget);
    expect(find.text('1 LOAN'), findsOneWidget);

    // Initially, inline loan details should NOT be visible
    expect(find.text('A/C LN-7749'), findsNothing);
    expect(find.text('NEW LOAN'), findsNothing);

    // Tap on the member row to trigger accordion expansion
    await tester.tap(find.text('Radhakrishnan Nair'));
    await tester.pumpAndSettle();

    // Now, inline expanded loan account details MUST be visible
    expect(find.text('ACTIVE LOAN ACCOUNTS'), findsOneWidget);
    expect(find.text('A/C LN-7749'), findsOneWidget);
    expect(find.text('BASE MONTHLY EMI'), findsOneWidget);
    expect(find.text('₹2200'), findsOneWidget);
    expect(find.text('NEW LOAN'), findsOneWidget);
    expect(find.text('FULL PROFILE'), findsOneWidget);

    // Tap again to collapse
    await tester.tap(find.text('Radhakrishnan Nair'));
    await tester.pumpAndSettle();

    expect(find.text('A/C LN-7749'), findsNothing);
  });
}

class _MockAppStateNotifier extends AppStateNotifier {
  final AppState _mockState;
  _MockAppStateNotifier(this._mockState);

  @override
  Future<AppState> build() async {
    return _mockState;
  }
}
