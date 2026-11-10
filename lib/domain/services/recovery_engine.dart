import 'package:uuid/uuid.dart';
import '../models/monthly_recovery.dart';
import '../models/loan.dart';
import '../repositories/i_loan_repository.dart';
import '../repositories/i_customer_repository.dart';
import '../repositories/i_recovery_repository.dart';

class GenerateDraftsResult {
  final int createdCount;
  final int skippedCount;
  final String message;

  const GenerateDraftsResult({
    required this.createdCount,
    required this.skippedCount,
    required this.message,
  });
}

/// Pure Dart financial calculation & recovery scheduling engine.
///
/// Direct translation of Python backend recovery generation logic from:
/// `backend/main.py:generate_drafts()` and `backend/main.py:update_recovery()`.
class RecoveryEngine {
  final ILoanRepository loanRepository;
  final ICustomerRepository customerRepository;
  final IRecoveryRepository recoveryRepository;
  final Uuid _uuid;

  RecoveryEngine({
    required this.loanRepository,
    required this.customerRepository,
    required this.recoveryRepository,
    Uuid? uuid,
  }) : _uuid = uuid ?? const Uuid();

  /// Generates recovery schedules/drafts for active loans for a given month & year.
  ///
  /// Calculation Rules (matching backend/main.py):
  /// - Interest = round(Principal Outstanding * 0.01, 2) [1% monthly simple interest]
  /// - Principal Due = round(Base EMI - Interest, 2)
  /// - Edge Case: If Base EMI < Interest, Principal Due = Base EMI, Interest = 0.0
  /// - Idempotent: Skips loans that already have a recovery record for this (loanId, month, year).
  Future<GenerateDraftsResult> generateDrafts({
    required int month,
    required int year,
    String? officeId,
  }) async {
    List<Loan> activeLoans;

    if (officeId != null) {
      final customers = await customerRepository.getAllCustomers(officeId: officeId);
      final customerIds = customers.map((c) => c.id).toList();

      if (customerIds.isEmpty) {
        return const GenerateDraftsResult(
          createdCount: 0,
          skippedCount: 0,
          message: 'No members found in the selected unit.',
        );
      }

      activeLoans = await loanRepository.getLoansByCustomerIds(
        customerIds,
        statuses: ['Active', 'ACTIVE'],
      );
    } else {
      activeLoans = await loanRepository.getAllLoans(statuses: ['Active', 'ACTIVE']);
    }

    final List<MonthlyRecovery> newDrafts = [];
    int skippedCount = 0;

    for (final loan in activeLoans) {
      // Check if draft already exists
      final existing = await recoveryRepository.getRecoveryByLoanAndPeriod(
        loan.id,
        month,
        year,
      );

      if (existing != null) {
        skippedCount++;
        continue;
      }

      // Calculation logic
      double interest = roundCurrency(loan.principalOutstanding * 0.01);
      double principalDue = roundCurrency(loan.baseEmiAmount - interest);

      // Edge case guard (where base EMI is very low or 0)
      if (principalDue < 0) {
        principalDue = loan.baseEmiAmount;
        interest = 0.0;
      }

      final draft = MonthlyRecovery(
        id: _uuid.v4(),
        loanId: loan.id,
        month: month,
        year: year,
        principalDue: principalDue,
        interest: interest,
        penalInterest: 0.0,
        otherCharges: 0.0,
        isReviewed: false,
      );

      newDrafts.add(draft);
    }

    if (newDrafts.isNotEmpty) {
      await recoveryRepository.saveBatchRecoveries(newDrafts);
    }

    return GenerateDraftsResult(
      createdCount: newDrafts.length,
      skippedCount: skippedCount,
      message: '${newDrafts.length} drafts generated for the selected unit.',
    );
  }

  /// Adjusts specific line items of an existing recovery record.
  ///
  /// Translates PATCH /recoveries/{id} from backend/main.py.
  Future<MonthlyRecovery> adjustRecoveryDraft({
    required String recoveryId,
    double? principalDue,
    double? interest,
    double? penalInterest,
    double? otherCharges,
  }) async {
    final existing = await recoveryRepository.getRecoveryById(recoveryId);
    if (existing == null) {
      throw StateError('MonthlyRecovery with ID $recoveryId does not exist.');
    }

    final updated = existing.copyWith(
      principalDue: principalDue != null ? roundCurrency(principalDue) : null,
      interest: interest != null ? roundCurrency(interest) : null,
      penalInterest: penalInterest != null ? roundCurrency(penalInterest) : null,
      otherCharges: otherCharges != null ? roundCurrency(otherCharges) : null,
      isReviewed: true,
    );

    return await recoveryRepository.updateRecovery(updated);
  }

  /// Utility to round floating point values to 2 decimal places.
  static double roundCurrency(double val) {
    return (val * 100).roundToDouble() / 100.0;
  }
}

