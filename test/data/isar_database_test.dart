import 'dart:ffi';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:loan_recovery/data/local/isar_database_service.dart';
import 'package:loan_recovery/data/repositories/isar_office_repository.dart';
import 'package:loan_recovery/data/repositories/isar_customer_repository.dart';
import 'package:loan_recovery/data/repositories/isar_loan_repository.dart';
import 'package:loan_recovery/data/repositories/isar_recovery_repository.dart';
import 'package:loan_recovery/domain/services/loan_ledger_service.dart';
import 'package:loan_recovery/domain/services/recovery_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late IsarDatabaseService dbService;
  late IsarOfficeRepository officeRepo;
  late IsarCustomerRepository customerRepo;
  late IsarLoanRepository loanRepo;
  late IsarRecoveryRepository recoveryRepo;
  late LoanLedgerService ledgerService;
  late RecoveryEngine recoveryEngine;

  setUpAll(() async {
    final dylibPath = '${Platform.environment['HOME']}/.pub-cache/hosted/pub.dev/isar_community_flutter_libs-3.4.1/macos/libisar.dylib';
    if (File(dylibPath).existsSync()) {
      await Isar.initializeIsarCore(libraries: {
        Abi.current(): dylibPath,
      });
    } else {
      await Isar.initializeIsarCore();
    }
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_test_');
    dbService = IsarDatabaseService(customDirectory: tempDir.path);
    officeRepo = IsarOfficeRepository(dbService: dbService);
    customerRepo = IsarCustomerRepository(dbService: dbService);
    loanRepo = IsarLoanRepository(dbService: dbService);
    recoveryRepo = IsarRecoveryRepository(dbService: dbService);

    ledgerService = LoanLedgerService(
      officeRepo: officeRepo,
      customerRepo: customerRepo,
      loanRepo: loanRepo,
      recoveryRepo: recoveryRepo,
    );

    recoveryEngine = RecoveryEngine(
      loanRepository: loanRepo,
      customerRepository: customerRepo,
      recoveryRepository: recoveryRepo,
    );
  });

  tearDown(() async {
    await dbService.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('Isar full integration: create branch, member, loan, generate drafts, and verify calculations', () async {
    // 1. Create Office
    final office = await ledgerService.createOffice(name: 'Adoor HPO');
    expect(office.name, 'Adoor HPO');

    final fetchedOffices = await officeRepo.getAllOffices();
    expect(fetchedOffices.length, 1);
    expect(fetchedOffices.first.id, office.id);

    // 2. Register Member
    final customer = await ledgerService.registerCustomer(
      officeId: office.id,
      memberNo: 'AD-101',
      name: 'Vipin Das',
    );
    expect(customer.name, 'Vipin Das');

    final fetchedCustomers = await customerRepo.getAllCustomers(officeId: office.id);
    expect(fetchedCustomers.length, 1);

    // 3. Initialize Loan: 100,000 principal, 5,000 base EMI
    final loan = await ledgerService.initializeLoan(
      customerId: customer.id,
      accountNo: '10/26-27',
      principalOutstanding: 100000.0,
      baseEmiAmount: 5000.0,
    );
    expect(loan.principalOutstanding, 100000.0);

    // 4. Generate Drafts for May 2026
    final result = await recoveryEngine.generateDrafts(
      month: 5,
      year: 2026,
      officeId: office.id,
    );
    expect(result.createdCount, 1);

    // 5. Query draft from Isar and verify financial calculation
    final draft = await recoveryRepo.getRecoveryByLoanAndPeriod(loan.id, 5, 2026);
    expect(draft, isNotNull);
    // Principal Due = 5,000.0
    // Reduced Outstanding = 100,000 - 5,000 = 95,000.0
    // 1% of 95,000 = 950.0
    expect(draft!.interest, 950.0);
    expect(draft.principalDue, 5000.0);
    expect(draft.totalRecovered, 5950.0);

    // 6. Adjust draft line items in Isar
    final adjusted = await recoveryEngine.adjustRecoveryDraft(
      recoveryId: draft.id,
      penalInterest: 150.0,
      otherCharges: 50.0,
    );
    expect(adjusted.penalInterest, 150.0);
    expect(adjusted.otherCharges, 50.0);
    expect(adjusted.totalRecovered, 6150.0);

    // Verify persistence of adjusted draft in Isar
    final reFetched = await recoveryRepo.getRecoveryById(draft.id);
    expect(reFetched!.totalRecovered, 6150.0);
    expect(reFetched.isReviewed, true);

    // 7. Verify Cascade Deletion in Isar
    await ledgerService.deleteOfficeCascade(office.id);
    expect(await officeRepo.getAllOffices(), isEmpty);
    expect(await customerRepo.getAllCustomers(), isEmpty);
    expect(await loanRepo.getAllLoans(), isEmpty);
    expect(await recoveryRepo.getRecoveries(), isEmpty);
  });
}
