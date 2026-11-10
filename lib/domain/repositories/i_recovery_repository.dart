import '../models/monthly_recovery.dart';

abstract class IRecoveryRepository {
  /// Fetches recoveries, optionally filtered by month, year, or loanIds.
  Future<List<MonthlyRecovery>> getRecoveries({
    int? month,
    int? year,
    List<String>? loanIds,
  });

  /// Fetches a specific draft for a loan in a given month and year.
  Future<MonthlyRecovery?> getRecoveryByLoanAndPeriod(
    String loanId,
    int month,
    int year,
  );

  /// Fetches a recovery record by its ID.
  Future<MonthlyRecovery?> getRecoveryById(String id);

  /// Saves or creates a recovery.
  Future<MonthlyRecovery> saveRecovery(MonthlyRecovery recovery);

  /// Batch inserts or updates monthly recoveries.
  Future<void> saveBatchRecoveries(List<MonthlyRecovery> recoveries);

  /// Updates an existing monthly recovery.
  Future<MonthlyRecovery> updateRecovery(MonthlyRecovery recovery);

  /// Deletes a recovery by ID.
  Future<void> deleteRecovery(String id);

  /// Deletes all recoveries linked to a loan.
  Future<void> deleteRecoveriesByLoanId(String loanId);

  /// Wipes all monthly recoveries (useful for resetting/seeding data).
  Future<void> clearAllRecoveries();
}

