import '../../domain/models/loan.dart';
import '../../domain/repositories/i_loan_repository.dart';

class InMemoryLoanRepository implements ILoanRepository {
  final Map<String, Loan> _storage = {};

  InMemoryLoanRepository([List<Loan>? initial]) {
    if (initial != null) {
      for (final loan in initial) {
        _storage[loan.id] = loan;
      }
    }
  }

  @override
  Future<List<Loan>> getAllLoans({
    String? customerId,
    List<String>? statuses,
  }) async {
    return _storage.values.where((l) {
      if (customerId != null && l.customerId != customerId) return false;
      if (statuses != null && !statuses.contains(l.status)) return false;
      return true;
    }).toList();
  }

  @override
  Future<List<Loan>> getLoansByCustomerIds(
    List<String> customerIds, {
    List<String>? statuses,
  }) async {
    final idSet = customerIds.toSet();
    return _storage.values.where((l) {
      if (!idSet.contains(l.customerId)) return false;
      if (statuses != null && !statuses.contains(l.status)) return false;
      return true;
    }).toList();
  }

  @override
  Future<Loan?> getLoanById(String id) async {
    return _storage[id];
  }

  @override
  Future<Loan> saveLoan(Loan loan) async {
    _storage[loan.id] = loan;
    return loan;
  }

  @override
  Future<void> deleteLoan(String id) async {
    _storage.remove(id);
  }

  @override
  Future<void> deleteLoansByCustomerId(String customerId) async {
    _storage.removeWhere((_, l) => l.customerId == customerId);
  }

  @override
  Future<void> clearAllLoans() async {
    _storage.clear();
  }
}

