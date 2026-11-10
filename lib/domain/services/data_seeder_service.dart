import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/office.dart';
import '../models/customer.dart';
import '../models/loan.dart';
import '../repositories/i_office_repository.dart';
import '../repositories/i_customer_repository.dart';
import '../repositories/i_loan_repository.dart';
import '../repositories/i_recovery_repository.dart';

enum ImportConflictAction {
  replace, // Delete old records for the branch and insert new
  keepExisting, // Keep old records and skip new ones
}

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

/// Service managing database resets, PDF data ingestion, and conflict handling.
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

  /// Wipes all data across all collections in the local database.
  Future<void> clearDatabase() async {
    await recoveryRepo.clearAllRecoveries();
    await loanRepo.clearAllLoans();
    await customerRepo.clearAllCustomers();
    await officeRepo.clearAllOffices();
  }

  /// Returns list of branch names from the dataset that already exist in the database.
  Future<List<String>> findConflictingBranches(
      List<String> incomingBranchNames) async {
    final existingOffices = await officeRepo.getAllOffices();
    final existingNames =
        existingOffices.map((o) => o.name.toLowerCase()).toSet();
    return incomingBranchNames
        .where((b) => existingNames.contains(b.toLowerCase()))
        .toList();
  }

  /// Seeds data from a JSON string (e.g. extracted_data.json or asset file).
  Future<SeederResult> seedFromJsonString(
    String jsonString, {
    bool wipeExisting = false,
    ImportConflictAction conflictAction = ImportConflictAction.replace,
  }) async {
    final Map<String, dynamic> data = json.decode(jsonString);
    return seedFromMap(
      data,
      wipeExisting: wipeExisting,
      conflictAction: conflictAction,
    );
  }

  /// Seeds data from a structured map with conflict management.
  Future<SeederResult> seedFromMap(
    Map<String, dynamic> data, {
    bool wipeExisting = false,
    ImportConflictAction conflictAction = ImportConflictAction.replace,
  }) async {
    if (wipeExisting) {
      await clearDatabase();
    }

    final existingOffices = await officeRepo.getAllOffices();
    final officeMapByName = {
      for (final o in existingOffices) o.name.toLowerCase(): o
    };

    int officesCreated = 0;
    int customersCreated = 0;
    int loansCreated = 0;

    for (final entry in data.entries) {
      final branchName = entry.key;
      if (branchName == 'Unknown') continue;

      final records = entry.value as List<dynamic>;
      final lowerName = branchName.toLowerCase();
      final existingOffice = officeMapByName[lowerName];

      String officeId;

      if (existingOffice != null) {
        if (conflictAction == ImportConflictAction.keepExisting) {
          // User chose to keep old records: skip this branch
          continue;
        } else {
          // User chose to replace: delete existing customers & loans for this office
          officeId = existingOffice.id;
          final existingCustomers =
              await customerRepo.getAllCustomers(officeId: officeId);
          for (final c in existingCustomers) {
            await loanRepo.deleteLoansByCustomerId(c.id);
          }
          await customerRepo.deleteCustomersByOfficeId(officeId);
        }
      } else {
        officeId = _uuid.v4();
        final office = Office(
          id: officeId,
          branchId: branchName.toLowerCase().replaceAll(' ', '_'),
          name: branchName,
        );
        await officeRepo.saveOffice(office);
        officesCreated++;
      }

      // Track customers within this branch to deduplicate by membership number
      final Map<String, String> branchCustomerMap = {};

      for (final rawRecord in records) {
        final rec = rawRecord as Map<String, dynamic>;
        final memberNo = rec['member_no']?.toString() ?? '';
        final customerName = rec['name']?.toString() ?? 'Unknown';

        // Create customer if not already registered in this branch
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

        // Create Loan
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
