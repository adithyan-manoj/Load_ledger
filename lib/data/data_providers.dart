import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/office.dart';
import '../domain/models/customer.dart';
import '../domain/models/loan.dart';
import '../domain/models/monthly_recovery.dart';
import '../domain/repositories/i_office_repository.dart';
import '../domain/repositories/i_customer_repository.dart';
import '../domain/repositories/i_loan_repository.dart';
import '../domain/repositories/i_recovery_repository.dart';
import '../domain/services/loan_ledger_service.dart';
import '../domain/services/recovery_engine.dart';
import 'local/isar_database_service.dart';
import 'repositories/isar_office_repository.dart';
import 'repositories/isar_customer_repository.dart';
import 'repositories/isar_loan_repository.dart';
import 'repositories/isar_recovery_repository.dart';

// ==========================================
// Database & Repository Providers
// ==========================================

final isarDatabaseServiceProvider = Provider<IsarDatabaseService>((ref) {
  final service = IsarDatabaseService();
  ref.onDispose(() => service.close());
  return service;
});

final officeRepositoryProvider = Provider<IOfficeRepository>((ref) {
  return IsarOfficeRepository(dbService: ref.watch(isarDatabaseServiceProvider));
});

final customerRepositoryProvider = Provider<ICustomerRepository>((ref) {
  return IsarCustomerRepository(dbService: ref.watch(isarDatabaseServiceProvider));
});

final loanRepositoryProvider = Provider<ILoanRepository>((ref) {
  return IsarLoanRepository(dbService: ref.watch(isarDatabaseServiceProvider));
});

final recoveryRepositoryProvider = Provider<IRecoveryRepository>((ref) {
  return IsarRecoveryRepository(dbService: ref.watch(isarDatabaseServiceProvider));
});

final loanLedgerServiceProvider = Provider<LoanLedgerService>((ref) {
  return LoanLedgerService(
    officeRepo: ref.watch(officeRepositoryProvider),
    customerRepo: ref.watch(customerRepositoryProvider),
    loanRepo: ref.watch(loanRepositoryProvider),
    recoveryRepo: ref.watch(recoveryRepositoryProvider),
  );
});

final recoveryEngineProvider = Provider<RecoveryEngine>((ref) {
  return RecoveryEngine(
    loanRepository: ref.watch(loanRepositoryProvider),
    customerRepository: ref.watch(customerRepositoryProvider),
    recoveryRepository: ref.watch(recoveryRepositoryProvider),
  );
});

// ==========================================
// Central App State & Notifier
// ==========================================

class AppState {
  final List<Office> offices;
  final List<Customer> customers;
  final List<Loan> loans;
  final List<MonthlyRecovery> monthlyRecoveries;

  const AppState({
    required this.offices,
    required this.customers,
    required this.loans,
    required this.monthlyRecoveries,
  });

  AppState copyWith({
    List<Office>? offices,
    List<Customer>? customers,
    List<Loan>? loans,
    List<MonthlyRecovery>? monthlyRecoveries,
  }) {
    return AppState(
      offices: offices ?? this.offices,
      customers: customers ?? this.customers,
      loans: loans ?? this.loans,
      monthlyRecoveries: monthlyRecoveries ?? this.monthlyRecoveries,
    );
  }
}

class AppStateNotifier extends AsyncNotifier<AppState> {
  @override
  Future<AppState> build() async {
    final officeRepo = ref.watch(officeRepositoryProvider);
    final customerRepo = ref.watch(customerRepositoryProvider);
    final loanRepo = ref.watch(loanRepositoryProvider);
    final recoveryRepo = ref.watch(recoveryRepositoryProvider);

    // Fetch all core data in parallel directly from local Isar database
    final results = await Future.wait([
      officeRepo.getAllOffices(),
      customerRepo.getAllCustomers(),
      loanRepo.getAllLoans(),
      recoveryRepo.getRecoveries(),
    ]);

    return AppState(
      offices: results[0] as List<Office>,
      customers: results[1] as List<Customer>,
      loans: results[2] as List<Loan>,
      monthlyRecoveries: results[3] as List<MonthlyRecovery>,
    );
  }

  Future<void> addBranch(String name) async {
    if (name.trim().isEmpty) return;

    final ledgerService = ref.read(loanLedgerServiceProvider);
    final savedOffice = await ledgerService.createOffice(name: name);

    state = state.whenData((current) => current.copyWith(
          offices: [...current.offices, savedOffice],
        ));
  }

  Future<void> deleteBranch(String officeId) async {
    final ledgerService = ref.read(loanLedgerServiceProvider);
    await ledgerService.deleteOfficeCascade(officeId);

    // Refresh state after cascade deletion
    ref.invalidateSelf();
  }

  Future<void> addEmployee(String branchId, String name, String memberNo) async {
    if (name.trim().isEmpty || memberNo.trim().isEmpty) return;

    final ledgerService = ref.read(loanLedgerServiceProvider);
    final savedCustomer = await ledgerService.registerCustomer(
      officeId: branchId,
      memberNo: memberNo,
      name: name,
    );

    state = state.whenData((current) => current.copyWith(
          customers: [...current.customers, savedCustomer],
        ));
  }

  Future<void> deleteEmployee(String customerId) async {
    final ledgerService = ref.read(loanLedgerServiceProvider);
    await ledgerService.deleteCustomerCascade(customerId);

    // Refresh state after cascade deletion
    ref.invalidateSelf();
  }

  Future<void> addLoan(
    String customerId,
    String accountNo,
    double principalOS,
    double baseEmi,
  ) async {
    if (accountNo.trim().isEmpty) return;

    final ledgerService = ref.read(loanLedgerServiceProvider);
    final savedLoan = await ledgerService.initializeLoan(
      customerId: customerId,
      accountNo: accountNo,
      principalOutstanding: principalOS,
      baseEmiAmount: baseEmi,
    );

    state = state.whenData((current) => current.copyWith(
          loans: [...current.loans, savedLoan],
        ));
  }

  Future<void> deleteLoan(String loanId) async {
    final ledgerService = ref.read(loanLedgerServiceProvider);
    await ledgerService.deleteLoanCascade(loanId);

    // Refresh state after cascade deletion
    ref.invalidateSelf();
  }

  Future<void> updateDraft(
    String draftId, {
    double? principalDue,
    double? interest,
    double? penalInt,
    double? others,
  }) async {
    final recoveryEngine = ref.read(recoveryEngineProvider);
    final updatedDraft = await recoveryEngine.adjustRecoveryDraft(
      recoveryId: draftId,
      principalDue: principalDue,
      interest: interest,
      penalInterest: penalInt,
      otherCharges: others,
    );

    state = state.whenData((current) {
      final index = current.monthlyRecoveries.indexWhere((d) => d.id == draftId);
      if (index >= 0) {
        final newDrafts = List<MonthlyRecovery>.from(current.monthlyRecoveries);
        newDrafts[index] = updatedDraft;
        return current.copyWith(monthlyRecoveries: newDrafts);
      }
      return current;
    });
  }

  Future<String> generateDrafts(int month, int year, {required String branchId}) async {
    final recoveryEngine = ref.read(recoveryEngineProvider);
    final recoveryRepo = ref.read(recoveryRepositoryProvider);

    final result = await recoveryEngine.generateDrafts(
      month: month,
      year: year,
      officeId: branchId,
    );

    // Refresh local recoveries in state
    final allRecoveries = await recoveryRepo.getRecoveries();
    state = state.whenData((current) => current.copyWith(monthlyRecoveries: allRecoveries));

    return result.message;
  }
}

final appStateProvider =
    AsyncNotifierProvider<AppStateNotifier, AppState>(AppStateNotifier.new);
