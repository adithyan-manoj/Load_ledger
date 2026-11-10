import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/domain/models/customer.dart';
import 'package:loan_recovery/domain/models/loan.dart';
import 'package:loan_recovery/domain/services/recovery_engine.dart';
import 'package:loan_recovery/data/repositories/in_memory_customer_repository.dart';
import 'package:loan_recovery/data/repositories/in_memory_loan_repository.dart';
import 'package:loan_recovery/data/repositories/in_memory_recovery_repository.dart';

void main() {
  group('RecoveryEngine Tests', () {
    late InMemoryCustomerRepository customerRepo;
    late InMemoryLoanRepository loanRepo;
    late InMemoryRecoveryRepository recoveryRepo;
    late RecoveryEngine engine;

    setUp(() {
      customerRepo = InMemoryCustomerRepository();
      loanRepo = InMemoryLoanRepository();
      recoveryRepo = InMemoryRecoveryRepository();
      engine = RecoveryEngine(
        loanRepository: loanRepo,
        customerRepository: customerRepo,
        recoveryRepository: recoveryRepo,
      );
    });

    test('reduces principal due from outstanding and calculates 12% interest on new amount', () async {
      // 1. Setup sample customer and loan: Outstanding 50,000, Base Principal Due 5,000
      await customerRepo.saveCustomer(const Customer(
        id: 'c1',
        officeId: 'o1',
        memberNo: '101',
        name: 'John Doe',
      ));

      await loanRepo.saveLoan(const Loan(
        id: 'l1',
        customerId: 'c1',
        accountNo: '15/25-26',
        principalOutstanding: 50000.0,
        baseEmiAmount: 5000.0,
      ));

      // 2. Generate drafts for April 2026
      final result = await engine.generateDrafts(month: 4, year: 2026);

      expect(result.createdCount, 1);
      expect(result.skippedCount, 0);

      final recoveries = await recoveryRepo.getRecoveries(month: 4, year: 2026);
      expect(recoveries.length, 1);

      final recovery = recoveries.first;
      // Principal Due remains constant = 5,000.0
      expect(recovery.principalDue, 5000.0);
      // Reduced Balance = 50,000 - 5,000 = 45,000.0
      // 12% p.a. (1% monthly) on 45,000 = 450.0
      expect(recovery.interest, 450.0);
      expect(recovery.penalInterest, 0.0);
      expect(recovery.otherCharges, 0.0);
      // Total monthly recovery demand = Principal Due + Interest = 5,450.0
      expect(recovery.totalRecovered, 5450.0);
    });

    test('handles edge case where principal outstanding is less than base installment', () async {
      // Terminal loan installment: Outstanding is only 3,200, but regular installment is 5,000
      await customerRepo.saveCustomer(const Customer(
        id: 'c2',
        officeId: 'o1',
        memberNo: '102',
        name: 'Jane Smith',
      ));

      await loanRepo.saveLoan(const Loan(
        id: 'l2',
        customerId: 'c2',
        accountNo: '20/25-26',
        principalOutstanding: 3200.0,
        baseEmiAmount: 5000.0,
      ));

      final result = await engine.generateDrafts(month: 5, year: 2026);
      expect(result.createdCount, 1);

      final recovery = (await recoveryRepo.getRecoveries(month: 5, year: 2026)).first;
      // Capped to remaining balance: 3,200.0
      expect(recovery.principalDue, 3200.0);
      // Reduced balance: 3,200 - 3,200 = 0.0 => interest = 0.0
      expect(recovery.interest, 0.0);
      expect(recovery.totalRecovered, 3200.0);
    });

    test('guarantees idempotency (does not duplicate existing monthly drafts)', () async {
      await customerRepo.saveCustomer(const Customer(
        id: 'c3',
        officeId: 'o1',
        memberNo: '103',
        name: 'Alice',
      ));

      await loanRepo.saveLoan(const Loan(
        id: 'l3',
        customerId: 'c3',
        accountNo: '30/25-26',
        principalOutstanding: 20000.0,
        baseEmiAmount: 2000.0,
      ));

      // Run 1
      final res1 = await engine.generateDrafts(month: 6, year: 2026);
      expect(res1.createdCount, 1);
      expect(res1.skippedCount, 0);

      // Run 2 (duplicate trigger)
      final res2 = await engine.generateDrafts(month: 6, year: 2026);
      expect(res2.createdCount, 0);
      expect(res2.skippedCount, 1);

      final count = (await recoveryRepo.getRecoveries(month: 6, year: 2026)).length;
      expect(count, 1);
    });

    test('adjustRecoveryDraft updates penal interest and charges correctly', () async {
      await customerRepo.saveCustomer(const Customer(
        id: 'c4',
        officeId: 'o1',
        memberNo: '104',
        name: 'Bob',
      ));

      await loanRepo.saveLoan(const Loan(
        id: 'l4',
        customerId: 'c4',
        accountNo: '40/25-26',
        principalOutstanding: 30000.0,
        baseEmiAmount: 3000.0,
      ));

      await engine.generateDrafts(month: 7, year: 2026);
      final draft = (await recoveryRepo.getRecoveries(month: 7, year: 2026)).first;

      final updated = await engine.adjustRecoveryDraft(
        recoveryId: draft.id,
        penalInterest: 75.0,
        otherCharges: 25.0,
      );

      expect(updated.penalInterest, 75.0);
      expect(updated.otherCharges, 25.0);
      expect(updated.isReviewed, true);
      expect(updated.totalRecovered, draft.principalDue + draft.interest + 75.0 + 25.0);
    });
  });
}
