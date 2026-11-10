import 'package:flutter_test/flutter_test.dart';
import 'package:loan_recovery/domain/services/data_seeder_service.dart';
import 'package:loan_recovery/data/repositories/in_memory_office_repository.dart';
import 'package:loan_recovery/data/repositories/in_memory_customer_repository.dart';
import 'package:loan_recovery/data/repositories/in_memory_loan_repository.dart';
import 'package:loan_recovery/data/repositories/in_memory_recovery_repository.dart';

void main() {
  group('DataSeederService Tests', () {
    test('seeds data from map structure correctly and deduplicates customers',
        () async {
      final officeRepo = InMemoryOfficeRepository();
      final customerRepo = InMemoryCustomerRepository();
      final loanRepo = InMemoryLoanRepository();
      final recoveryRepo = InMemoryRecoveryRepository();

      final seeder = DataSeederService(
        officeRepo: officeRepo,
        customerRepo: customerRepo,
        loanRepo: loanRepo,
        recoveryRepo: recoveryRepo,
      );

      final sampleData = {
        'Punalur': [
          {
            'member_no': '10',
            'name': 'Gopakumar',
            'account_no': '01/25-26',
            'base_emi': 5000.0,
            'principal_os': 60000.0,
          },
          // Same customer, second loan
          {
            'member_no': '10',
            'name': 'Gopakumar',
            'account_no': '02/25-26',
            'base_emi': 2500.0,
            'principal_os': 25000.0,
          },
          // Different customer
          {
            'member_no': '11',
            'name': 'Suresh',
            'account_no': '03/25-26',
            'base_emi': 4000.0,
            'principal_os': 40000.0,
          },
        ],
        'Unknown': [
          // Should be skipped
          {
            'member_no': '99',
            'name': 'Skip Me',
            'account_no': '99/99',
            'base_emi': 0.0,
            'principal_os': 0.0,
          }
        ]
      };

      final result = await seeder.seedFromMap(sampleData, wipeExisting: true);

      expect(result.officesCreated, 1);
      // Member 10 deduplicated: 2 unique customers (10 and 11)
      expect(result.customersCreated, 2);
      // 3 loans total for Punalur
      expect(result.loansCreated, 3);

      final offices = await officeRepo.getAllOffices();
      expect(offices.first.name, 'Punalur');

      final customers = await customerRepo.getAllCustomers();
      expect(customers.length, 2);

      final loans = await loanRepo.getAllLoans();
      expect(loans.length, 3);
    });

    test('detects conflicting branches and handles keepExisting vs replace',
        () async {
      final officeRepo = InMemoryOfficeRepository();
      final customerRepo = InMemoryCustomerRepository();
      final loanRepo = InMemoryLoanRepository();
      final recoveryRepo = InMemoryRecoveryRepository();

      final seeder = DataSeederService(
        officeRepo: officeRepo,
        customerRepo: customerRepo,
        loanRepo: loanRepo,
        recoveryRepo: recoveryRepo,
      );

      // Initial seed: Punalur with 1 customer
      await seeder.seedFromMap({
        'Punalur': [
          {
            'member_no': '10',
            'name': 'Old Customer',
            'account_no': '01/OLD',
            'base_emi': 1000.0,
            'principal_os': 10000.0,
          }
        ]
      }, wipeExisting: true);

      // 1. Detect conflicts
      final conflicts =
          await seeder.findConflictingBranches(['Punalur', 'Adoor']);
      expect(conflicts, ['Punalur']);

      // 2. Import with keepExisting -> should NOT modify Punalur
      final keepResult = await seeder.seedFromMap({
        'Punalur': [
          {
            'member_no': '99',
            'name': 'New Customer',
            'account_no': '01/NEW',
            'base_emi': 2000.0,
            'principal_os': 20000.0,
          }
        ]
      }, conflictAction: ImportConflictAction.keepExisting);

      expect(keepResult.customersCreated, 0);
      final custsAfterKeep = await customerRepo.getAllCustomers();
      expect(custsAfterKeep.first.name, 'Old Customer');

      // 3. Import with replace -> should overwrite Punalur's customers & loans
      final replaceResult = await seeder.seedFromMap({
        'Punalur': [
          {
            'member_no': '99',
            'name': 'Replaced Customer',
            'account_no': '01/REP',
            'base_emi': 3000.0,
            'principal_os': 30000.0,
          }
        ]
      }, conflictAction: ImportConflictAction.replace);

      expect(replaceResult.customersCreated, 1);
      final custsAfterReplace = await customerRepo.getAllCustomers();
      expect(custsAfterReplace.length, 1);
      expect(custsAfterReplace.first.name, 'Replaced Customer');
    });

    test('clearDatabase completely wipes all collections', () async {
      final officeRepo = InMemoryOfficeRepository();
      final customerRepo = InMemoryCustomerRepository();
      final loanRepo = InMemoryLoanRepository();
      final recoveryRepo = InMemoryRecoveryRepository();

      final seeder = DataSeederService(
        officeRepo: officeRepo,
        customerRepo: customerRepo,
        loanRepo: loanRepo,
        recoveryRepo: recoveryRepo,
      );

      await seeder.seedFromMap({
        'Punalur': [
          {
            'member_no': '1',
            'name': 'Test',
            'account_no': '01',
            'base_emi': 100.0,
            'principal_os': 1000.0,
          }
        ]
      });

      expect((await officeRepo.getAllOffices()).length, 1);

      await seeder.clearDatabase();

      expect((await officeRepo.getAllOffices()).isEmpty, isTrue);
      expect((await customerRepo.getAllCustomers()).isEmpty, isTrue);
      expect((await loanRepo.getAllLoans()).isEmpty, isTrue);
    });
  });
}
