import '../../domain/models/monthly_recovery.dart';
import '../../domain/repositories/i_recovery_repository.dart';

class InMemoryRecoveryRepository implements IRecoveryRepository {
  final Map<String, MonthlyRecovery> _storage = {};

  InMemoryRecoveryRepository([List<MonthlyRecovery>? initial]) {
    if (initial != null) {
      for (final r in initial) {
        _storage[r.id] = r;
      }
    }
  }

  @override
  Future<List<MonthlyRecovery>> getRecoveries({
    int? month,
    int? year,
    List<String>? loanIds,
  }) async {
    final loanIdSet = loanIds?.toSet();
    return _storage.values.where((r) {
      if (month != null && r.month != month) return false;
      if (year != null && r.year != year) return false;
      if (loanIdSet != null && !loanIdSet.contains(r.loanId)) return false;
      return true;
    }).toList();
  }

  @override
  Future<MonthlyRecovery?> getRecoveryByLoanAndPeriod(
    String loanId,
    int month,
    int year,
  ) async {
    for (final r in _storage.values) {
      if (r.loanId == loanId && r.month == month && r.year == year) {
        return r;
      }
    }
    return null;
  }

  @override
  Future<MonthlyRecovery?> getRecoveryById(String id) async {
    return _storage[id];
  }

  @override
  Future<MonthlyRecovery> saveRecovery(MonthlyRecovery recovery) async {
    _storage[recovery.id] = recovery;
    return recovery;
  }

  @override
  Future<void> saveBatchRecoveries(List<MonthlyRecovery> recoveries) async {
    for (final r in recoveries) {
      _storage[r.id] = r;
    }
  }

  @override
  Future<MonthlyRecovery> updateRecovery(MonthlyRecovery recovery) async {
    _storage[recovery.id] = recovery;
    return recovery;
  }

  @override
  Future<void> deleteRecovery(String id) async {
    _storage.remove(id);
  }

  @override
  Future<void> deleteRecoveriesByLoanId(String loanId) async {
    _storage.removeWhere((_, r) => r.loanId == loanId);
  }

  @override
  Future<void> clearAllRecoveries() async {
    _storage.clear();
  }
}

