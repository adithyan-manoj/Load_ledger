import '../models/loan.dart';

abstract class ILoanRepository {
  /// Fetches all loans, optionally filtered by customerId and/or statuses.
  Future<List<Loan>> getAllLoans({
    String? customerId,
    List<String>? statuses,
  });

  /// Fetches all loans for a batch of customer IDs.
  Future<List<Loan>> getLoansByCustomerIds(
    List<String> customerIds, {
    List<String>? statuses,
  });

  /// Fetches a loan by its unique ID.
  Future<Loan?> getLoanById(String id);

  /// Saves or creates a loan.
  Future<Loan> saveLoan(Loan loan);

  /// Deletes a loan by ID.
  Future<void> deleteLoan(String id);

  /// Deletes all loans associated with a customer.
  Future<void> deleteLoansByCustomerId(String customerId);

  /// Wipes all loans (useful for resetting/seeding data).
  Future<void> clearAllLoans();
}

