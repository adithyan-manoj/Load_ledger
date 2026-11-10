import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/domain/models/monthly_recovery.dart';
import 'package:loan_recovery/domain/services/loan_ledger_service.dart';
import 'package:loan_recovery/data/repositories/in_memory_office_repository.dart';
import 'package:loan_recovery/data/repositories/in_memory_customer_repository.dart';
import 'package:loan_recovery/data/repositories/in_memory_loan_repository.dart';
import 'package:loan_recovery/data/repositories/in_memory_recovery_repository.dart';

void main() {
  group('LoanLedgerService Tests', () {
    late InMemoryOfficeRepository officeRepo;
    late InMemoryCustomerRepository customerRepo;
    late InMemoryLoanRepository loanRepo;
    late InMemoryRecoveryRepository recoveryRepo;
    late LoanLedgerService service;

    setUp(() {
      officeRepo = InMemoryOfficeRepository();
      customerRepo = InMemoryCustomerRepository();
      loanRepo = InMemoryLoanRepository();
      recoveryRepo = InMemoryRecoveryRepository();
      service = LoanLedgerService(
        officeRepo: officeRepo,
        customerRepo: customerRepo,
        loanRepo: loanRepo,
        recoveryRepo: recoveryRepo,
      );
    });

    test('createOffice, registerCustomer, and initializeLoan succeed with valid data', () async {
      final office = await service.createOffice(name: 'Kollam HPO');
      expect(office.name, 'Kollam HPO');
      expect(office.branchId, 'kollam_hpo');

      final customer = await service.registerCustomer(
        officeId: office.id,
        memberNo: 'Q-100',
        name: 'Arun Kumar',
      );
      expect(customer.officeId, office.id);
      expect(customer.memberNo, 'Q-100');

      final loan = await service.initializeLoan(
        customerId: customer.id,
        accountNo: '01/26-27',
        principalOutstanding: 150000.0,
        baseEmiAmount: 7500.0,
      );
      expect(loan.customerId, customer.id);
      expect(loan.principalOutstanding, 150000.0);
    });

    test('deleteOfficeCascade wipes customers, loans, and recoveries recursively', () async {
      final office = await service.createOffice(name: 'Punalur Unit');
      final customer = await service.registerCustomer(
        officeId: office.id,
        memberNo: '55',
        name: 'Santhosh',
      );
      final loan = await service.initializeLoan(
        customerId: customer.id,
        accountNo: '05/25-26',
        principalOutstanding: 60000.0,
        baseEmiAmount: 4000.0,
      );

      await recoveryRepo.saveRecovery(MonthlyRecovery(
        id: 'r1',
        loanId: loan.id,
        month: 5,
        year: 2026,
        principalDue: 3400.0,
        interest: 600.0,
      ));

      // Trigger cascade deletion
      await service.deleteOfficeCascade(office.id);

      expect(await officeRepo.getOfficeById(office.id), isNull);
      expect(await customerRepo.getCustomerById(customer.id), isNull);
      expect(await loanRepo.getLoanById(loan.id), isNull);
      expect(await recoveryRepo.getRecoveryById('r1'), isNull);
    });
  });
}

