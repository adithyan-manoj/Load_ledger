import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/office.dart';
import '../models/customer.dart';
import '../models/loan.dart';
import '../repositories/i_office_repository.dart';
import '../repositories/i_customer_repository.dart';
import '../repositories/i_loan_repository.dart';
import '../repositories/i_recovery_repository.dart';

class SeederResult {
  final int officesCreated;
  final int customersCreated;
  final int loansCreated;

  const SeederResult({
    required this.officesCreated,
    required this.customersCreated,
    required this.loansCreated,
  });

  @override
  String toString() =>
      'SeederResult(offices: $officesCreated, customers: $customersCreated, loans: $loansCreated)';
}

/// Port of backend/populate_db.py to pure Dart.
///
/// Enables seeding local embedded databases from extracted_data.json or bundled assets.
class DataSeederService {
  final IOfficeRepository officeRepo;
  final ICustomerRepository customerRepo;
  final ILoanRepository loanRepo;
  final IRecoveryRepository recoveryRepo;
  final Uuid _uuid;

  DataSeederService({
    required this.officeRepo,
    required this.customerRepo,
    required this.loanRepo,
    required this.recoveryRepo,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  /// Seeds data from a JSON string (e.g. extracted_data.json or asset file).
  Future<SeederResult> seedFromJsonString(
    String jsonString, {
    bool wipeExisting = true,
  }) async {
    final Map<String, dynamic> data = json.decode(jsonString);
    return seedFromMap(data, wipeExisting: wipeExisting);
  }

  /// Seeds data from a structured map.
  Future<SeederResult> seedFromMap(
    Map<String, dynamic> data, {
    bool wipeExisting = true,
  }) async {
    if (wipeExisting) {
      // Cascaded wipe in safe foreign-key order
      await recoveryRepo.clearAllRecoveries();
      await loanRepo.clearAllLoans();
      await customerRepo.clearAllCustomers();
      await officeRepo.clearAllOffices();
    }

    int officesCreated = 0;
    int customersCreated = 0;
    int loansCreated = 0;

    for (final entry in data.entries) {
      final branchName = entry.key;
      if (branchName == 'Unknown') continue;

      final records = entry.value as List<dynamic>;

      // 1. Create Office
      final officeId = _uuid.v4();
      final office = Office(
        id: officeId,
        branchId: branchName.toLowerCase().replaceAll(' ', '_'),
        name: branchName,
      );
      await officeRepo.saveOffice(office);
      officesCreated++;

      // Track customers within this branch to deduplicate by membership number
      final Map<String, String> branchCustomerMap = {};

      for (final rawRecord in records) {
        final rec = rawRecord as Map<String, dynamic>;
        final memberNo = rec['member_no']?.toString() ?? '';
        final customerName = rec['name']?.toString() ?? 'Unknown';

        // 2. Create customer if not already registered in this branch
        if (!branchCustomerMap.containsKey(memberNo)) {
          final customerId = _uuid.v4();
          final customer = Customer(
            id: customerId,
            officeId: officeId,
            memberNo: memberNo,
            name: customerName,
          );
          await customerRepo.saveCustomer(customer);
          branchCustomerMap[memberNo] = customerId;
          customersCreated++;
        }

        final customerId = branchCustomerMap[memberNo]!;

        // 3. Create Loan
        final baseEmi = (rec['base_emi'] as num?)?.toDouble() ?? 0.0;
        final principalOs = (rec['principal_os'] as num?)?.toDouble() ?? 0.0;
        final accountNo = rec['account_no']?.toString() ?? '';

        final loan = Loan(
          id: _uuid.v4(),
          customerId: customerId,
          accountNo: accountNo,
          principalOutstanding: principalOs,
          baseEmiAmount: baseEmi,
          status: 'Active',
        );
        await loanRepo.saveLoan(loan);
        loansCreated++;
      }
    }

    return SeederResult(
      officesCreated: officesCreated,
      customersCreated: customersCreated,
      loansCreated: loansCreated,
    );
  }
}

