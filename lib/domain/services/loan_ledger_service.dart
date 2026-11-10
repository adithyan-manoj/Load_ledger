import 'package:uuid/uuid.dart';
import '../models/office.dart';
import '../models/customer.dart';
import '../models/loan.dart';
import '../models/monthly_recovery.dart';
import '../repositories/i_office_repository.dart';
import '../repositories/i_customer_repository.dart';
import '../repositories/i_loan_repository.dart';
import '../repositories/i_recovery_repository.dart';

/// Coordinator service managing lifecycle operations for Offices, Customers, and Loans.
///
/// Implements domain validations and enforces foreign-key cascade consistency in Dart.
class LoanLedgerService {
  final IOfficeRepository officeRepo;
  final ICustomerRepository customerRepo;
  final ILoanRepository loanRepo;
  final IRecoveryRepository recoveryRepo;
  final Uuid _uuid;

  LoanLedgerService({
    required this.officeRepo,
    required this.customerRepo,
    required this.loanRepo,
    required this.recoveryRepo,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  // ==========================================
  // Office / Branch Operations
  // ==========================================

  Future<List<Office>> getAllOffices() {
    return officeRepo.getAllOffices();
  }

  Future<Office?> getOfficeById(String id) {
    return officeRepo.getOfficeById(id);
  }

  Future<Office> createOffice({
    required String name,
    String? branchId,
    String? id,
  }) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      throw ArgumentError('Office name cannot be empty.');
    }

    final office = Office(
      id: id ?? _uuid.v4(),
      branchId: branchId ?? cleanName.toLowerCase().replaceAll(' ', '_'),
      name: cleanName,
    );

    return await officeRepo.saveOffice(office);
  }

  /// Cascaded deletion of an Office:
  /// Recursively deletes all associated Customers, their Loans, and Monthly Recoveries.
  Future<void> deleteOfficeCascade(String officeId) async {
    final customers = await customerRepo.getAllCustomers(officeId: officeId);
    for (final customer in customers) {
      await deleteCustomerCascade(customer.id);
    }
    await officeRepo.deleteOffice(officeId);
  }

  // ==========================================
  // Customer / Member Operations
  // ==========================================

  Future<List<Customer>> getCustomers({String? officeId}) {
    return customerRepo.getAllCustomers(officeId: officeId);
  }

  Future<Customer?> getCustomerById(String id) {
    return customerRepo.getCustomerById(id);
  }

  Future<Customer> registerCustomer({
    required String officeId,
    required String memberNo,
    required String name,
    String? id,
  }) async {
    final cleanName = name.trim();
    final cleanMemberNo = memberNo.trim();

    if (cleanName.isEmpty) {
      throw ArgumentError('Customer name cannot be empty.');
    }
    if (cleanMemberNo.isEmpty) {
      throw ArgumentError('Membership number cannot be empty.');
    }

    // Verify office exists
    final office = await officeRepo.getOfficeById(officeId);
    if (office == null) {
      throw StateError('Cannot register customer: Office $officeId does not exist.');
    }

    final customer = Customer(
      id: id ?? _uuid.v4(),
      officeId: officeId,
      memberNo: cleanMemberNo,
      name: cleanName,
    );

    return await customerRepo.saveCustomer(customer);
  }

  /// Cascaded deletion of a Customer:
  /// Deletes all associated Loans and Monthly Recoveries before deleting the Customer.
  Future<void> deleteCustomerCascade(String customerId) async {
    final loans = await loanRepo.getAllLoans(customerId: customerId);
    for (final loan in loans) {
      await deleteLoanCascade(loan.id);
    }
    await customerRepo.deleteCustomer(customerId);
  }

  // ==========================================
  // Loan Operations
  // ==========================================

  Future<List<Loan>> getLoans({String? customerId, List<String>? statuses}) {
    return loanRepo.getAllLoans(customerId: customerId, statuses: statuses);
  }

  Future<Loan?> getLoanById(String id) {
    return loanRepo.getLoanById(id);
  }

  Future<Loan> initializeLoan({
    required String customerId,
    required String accountNo,
    required double principalOutstanding,
    required double baseEmiAmount,
    String status = 'Active',
    String? id,
  }) async {
    final cleanAccountNo = accountNo.trim();
    if (cleanAccountNo.isEmpty) {
      throw ArgumentError('Loan account number cannot be empty.');
    }

    // Verify customer exists
    final customer = await customerRepo.getCustomerById(customerId);
    if (customer == null) {
      throw StateError('Cannot initialize loan: Customer $customerId does not exist.');
    }

    final loan = Loan(
      id: id ?? _uuid.v4(),
      customerId: customerId,
      accountNo: cleanAccountNo,
      principalOutstanding: principalOutstanding < 0 ? 0.0 : principalOutstanding,
      baseEmiAmount: baseEmiAmount < 0 ? 0.0 : baseEmiAmount,
      status: status,
    );

    return await loanRepo.saveLoan(loan);
  }

  /// Cascaded deletion of a Loan:
  /// Purges all recovery drafts linked to this loan before deleting the loan account.
  Future<void> deleteLoanCascade(String loanId) async {
    await recoveryRepo.deleteRecoveriesByLoanId(loanId);
    await loanRepo.deleteLoan(loanId);
  }

  // ==========================================
  // Recovery Queries
  // ==========================================

  Future<List<MonthlyRecovery>> getRecoveries({int? month, int? year, List<String>? loanIds}) {
    return recoveryRepo.getRecoveries(month: month, year: year, loanIds: loanIds);
  }
}

