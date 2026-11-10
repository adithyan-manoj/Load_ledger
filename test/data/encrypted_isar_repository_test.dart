import 'dart:ffi';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:loan_recovery/core/security/cipher_service.dart';
import 'package:loan_recovery/data/local/isar_database_service.dart';
import 'package:loan_recovery/data/local/schemas/customer_collection.dart';
import 'package:loan_recovery/data/local/schemas/loan_collection.dart';
import 'package:loan_recovery/data/local/schemas/monthly_recovery_collection.dart';
import 'package:loan_recovery/data/repositories/isar_customer_repository.dart';
import 'package:loan_recovery/data/repositories/isar_loan_repository.dart';
import 'package:loan_recovery/data/repositories/isar_office_repository.dart';
import 'package:loan_recovery/data/repositories/isar_recovery_repository.dart';
import 'package:loan_recovery/domain/models/customer.dart';
import 'package:loan_recovery/domain/models/loan.dart';
import 'package:loan_recovery/domain/models/office.dart';
import 'package:loan_recovery/domain/services/recovery_engine.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late IsarDatabaseService dbService;
  late CipherService cipherService;
  late IsarOfficeRepository officeRepo;
  late IsarCustomerRepository customerRepo;
  late IsarLoanRepository loanRepo;
  late IsarRecoveryRepository recoveryRepo;
  late RecoveryEngine recoveryEngine;

  setUpAll(() async {
    final dylibPath =
        '${Platform.environment['HOME']}/.pub-cache/hosted/pub.dev/isar_community_flutter_libs-3.4.1/macos/libisar.dylib';
    if (File(dylibPath).existsSync()) {
      await Isar.initializeIsarCore(libraries: {
        Abi.current(): dylibPath,
      });
    } else {
      await Isar.initializeIsarCore();
    }
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_enc_test_');
    dbService = IsarDatabaseService(customDirectory: tempDir.path);

    // 256-bit test key
    cipherService = CipherService(
      base64Key: 'MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTIzNDU2Nzg5MDE=',
    );

    officeRepo = IsarOfficeRepository(
      dbService: dbService,
      cipherService: cipherService,
    );
    customerRepo = IsarCustomerRepository(
      dbService: dbService,
      cipherService: cipherService,
    );
    loanRepo = IsarLoanRepository(
      dbService: dbService,
      cipherService: cipherService,
    );
    recoveryRepo = IsarRecoveryRepository(
      dbService: dbService,
      cipherService: cipherService,
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

  group('Phase 3: Transparent Repository Encryption Tests', () {
    test('Customer data is physically encrypted in Isar and decrypted in Domain',
        () async {
      final office = await officeRepo.saveOffice(
        const Office(id: 'off-1', branchId: 'punalur', name: 'Punalur Main'),
      );

      final customer = const Customer(
        id: 'cust-101',
        officeId: 'off-1',
        memberNo: 'MEM-8842',
        name: 'Preethi Radhakrishnan',
      );

      await customerRepo.saveCustomer(customer);

      // 1. Inspect RAW Isar Collection to prove encryption at rest
      final isar = await dbService.isar;
      final rawCustomers = await isar.customerCollections.where().findAll();
      expect(rawCustomers.length, 1);
      final raw = rawCustomers.first;

      // Assert that plaintext does NOT exist on disk
      expect(raw.name.contains('Preethi'), isFalse);
      expect(raw.memberNo.contains('MEM-8842'), isFalse);

      // Assert that values conform to standard <iv>:<ciphertext> envelope
      expect(raw.name.contains(':'), isTrue);
      expect(raw.memberNo.contains(':'), isTrue);

      // Relational index remains plaintext for fast indexing
      expect(raw.officeId, 'off-1');

      // 2. Read through Repository and assert transparent decryption
      final retrieved = await customerRepo.getCustomerById('cust-101');
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Preethi Radhakrishnan');
      expect(retrieved.memberNo, 'MEM-8842');
      expect(retrieved.officeId, office.id);
    });

    test(
        'Loan financial figures (balances, EMI) are encrypted at rest with semantic security',
        () async {
      final loan = const Loan(
        id: 'loan-501',
        customerId: 'cust-101',
        accountNo: 'LN/PNL/2026/99',
        principalOutstanding: 250000.0,
        baseEmiAmount: 8500.0,
        status: 'Active',
      );

      await loanRepo.saveLoan(loan);

      // 1. Verify raw collection in Isar
      final isar = await dbService.isar;
      final rawLoans = await isar.loanCollections.where().findAll();
      expect(rawLoans.length, 1);
      final raw = rawLoans.first;

      expect(raw.accountNo.contains('LN/PNL/2026/99'), isFalse);
      expect(raw.principalOutstandingEncrypted.contains('250000'), isFalse);
      expect(raw.baseEmiAmountEncrypted.contains('8500'), isFalse);

      expect(raw.accountNo.contains(':'), isTrue);
      expect(raw.principalOutstandingEncrypted.contains(':'), isTrue);
      expect(raw.baseEmiAmountEncrypted.contains(':'), isTrue);

      // Status and customerId remain indexed
      expect(raw.status, 'Active');
      expect(raw.customerId, 'cust-101');

      // 2. Querying by status still works with high performance
      final activeLoans =
          await loanRepo.getAllLoans(statuses: ['Active']);
      expect(activeLoans.length, 1);
      expect(activeLoans.first.accountNo, 'LN/PNL/2026/99');
      expect(activeLoans.first.principalOutstanding, 250000.0);
      expect(activeLoans.first.baseEmiAmount, 8500.0);
    });

    test(
        'MonthlyRecovery formulas and draft generation operate with 100% precision with encryption',
        () async {
      // Setup Office, Customer, Loan
      await officeRepo.saveOffice(
        const Office(id: 'off-2', branchId: 'adoor', name: 'Adoor Branch'),
      );
      await customerRepo.saveCustomer(
        const Customer(
          id: 'cust-202',
          officeId: 'off-2',
          memberNo: 'AD-200',
          name: 'Suresh Gopi',
        ),
      );
      await loanRepo.saveLoan(
        const Loan(
          id: 'loan-701',
          customerId: 'cust-202',
          accountNo: 'AD/LN/01',
          principalOutstanding: 100000.0, // 1 Lakh
          baseEmiAmount: 5000.0,
          status: 'Active',
        ),
      );

      // Generate Drafts via RecoveryEngine
      final draftResult = await recoveryEngine.generateDrafts(
        month: 6,
        year: 2026,
        officeId: 'off-2',
      );
      expect(draftResult.createdCount, 1);

      // 1. Check raw Isar collection for encryption of amounts
      final isar = await dbService.isar;
      final rawRecoveries =
          await isar.monthlyRecoveryCollections.where().findAll();
      expect(rawRecoveries.length, 1);
      final rawRec = rawRecoveries.first;

      // Amounts must be stored encrypted
      expect(rawRec.principalDueEncrypted.contains(':'), isTrue);
      expect(rawRec.interestEncrypted.contains(':'), isTrue);
      expect(rawRec.month, 6);
      expect(rawRec.year, 2026);
      expect(rawRec.loanId, 'loan-701');

      // 2. Read back via Repository and verify financial calculation
      final recovery = await recoveryRepo.getRecoveryByLoanAndPeriod(
        'loan-701',
        6,
        2026,
      );
      expect(recovery, isNotNull);

      // Principal Due = 5,000.0
      // Reduced Outstanding = 100,000 - 5,000 = 95,000.0
      // 1% interest on 95,000 = 950.0
      expect(recovery!.interest, 950.0);
      expect(recovery.principalDue, 5000.0);
      expect(recovery.totalRecovered, 5950.0);

      // 3. Update recovery figures and ensure re-encryption
      await recoveryRepo.updateRecoveryAmounts(
        id: recovery.id,
        principalDue: 4500.0,
        interest: 1000.0,
        penalInterest: 150.0,
        otherCharges: 50.0,
        isReviewed: true,
      );

      final updated = await recoveryRepo.getRecoveryById(recovery.id);
      expect(updated, isNotNull);
      expect(updated!.principalDue, 4500.0);
      expect(updated.penalInterest, 150.0);
      expect(updated.otherCharges, 50.0);
      expect(updated.isReviewed, isTrue);
      expect(updated.totalRecovered, 5700.0);
    });
  });
}
