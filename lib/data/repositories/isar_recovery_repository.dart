import 'package:isar_community/isar.dart';
import '../../domain/models/monthly_recovery.dart';
import '../../domain/repositories/i_recovery_repository.dart';
import '../local/isar_database_service.dart';
import '../local/schemas/monthly_recovery_collection.dart';

class IsarRecoveryRepository implements IRecoveryRepository {
  final IsarDatabaseService dbService;

  IsarRecoveryRepository({required this.dbService});

  @override
  Future<List<MonthlyRecovery>> getRecoveries({
    int? month,
    int? year,
    List<String>? loanIds,
  }) async {
    final isar = await dbService.isar;

    if (month == null && year == null && (loanIds == null || loanIds.isEmpty)) {
      final all = await isar.monthlyRecoveryCollections.where().findAll();
      return all.map((c) => c.toDomain()).toList();
    }

    if (loanIds != null && loanIds.isEmpty) {
      return [];
    }

    final collections = await isar.monthlyRecoveryCollections
        .filter()
        .optional(month != null, (q) => q.monthEqualTo(month!))
        .optional(year != null, (q) => q.yearEqualTo(year!))
        .optional(
          loanIds != null && loanIds.isNotEmpty,
          (q) => q.anyOf(loanIds!, (q2, String lid) => q2.loanIdEqualTo(lid)),
        )
        .findAll();

    return collections.map((c) => c.toDomain()).toList();
  }

  @override
  Future<MonthlyRecovery?> getRecoveryByLoanAndPeriod(
    String loanId,
    int month,
    int year,
  ) async {
    final isar = await dbService.isar;
    final collection = await isar.monthlyRecoveryCollections
        .filter()
        .loanIdEqualTo(loanId)
        .and()
        .monthEqualTo(month)
        .and()
        .yearEqualTo(year)
        .findFirst();

    return collection?.toDomain();
  }

  @override
  Future<MonthlyRecovery?> getRecoveryById(String id) async {
    final isar = await dbService.isar;
    final collection = await isar.monthlyRecoveryCollections
        .filter()
        .idEqualTo(id)
        .findFirst();

    return collection?.toDomain();
  }

  @override
  Future<MonthlyRecovery> saveRecovery(MonthlyRecovery recovery) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      final existing = await isar.monthlyRecoveryCollections
          .filter()
          .idEqualTo(recovery.id)
          .findFirst();
      final collection = MonthlyRecoveryCollection.fromDomain(recovery);
      if (existing != null) {
        collection.isarId = existing.isarId;
      }
      await isar.monthlyRecoveryCollections.put(collection);
    });
    return recovery;
  }

  @override
  Future<void> saveBatchRecoveries(List<MonthlyRecovery> recoveries) async {
    if (recoveries.isEmpty) return;
    final isar = await dbService.isar;

    await isar.writeTxn(() async {
      final ids = recoveries.map((r) => r.id).toList();
      final existingRecords = await isar.monthlyRecoveryCollections
          .filter()
          .anyOf(ids, (q, String id) => q.idEqualTo(id))
          .findAll();

      final existingMap = {for (final e in existingRecords) e.id: e.isarId};

      final toPut = recoveries.map((r) {
        final collection = MonthlyRecoveryCollection.fromDomain(r);
        if (existingMap.containsKey(r.id)) {
          collection.isarId = existingMap[r.id]!;
        }
        return collection;
      }).toList();

      await isar.monthlyRecoveryCollections.putAll(toPut);
    });
  }

  @override
  Future<MonthlyRecovery> updateRecovery(MonthlyRecovery recovery) async {
    return saveRecovery(recovery);
  }

  @override
  Future<void> deleteRecovery(String id) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.monthlyRecoveryCollections
          .filter()
          .idEqualTo(id)
          .deleteAll();
    });
  }

  @override
  Future<void> deleteRecoveriesByLoanId(String loanId) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.monthlyRecoveryCollections
          .filter()
          .loanIdEqualTo(loanId)
          .deleteAll();
    });
  }

  @override
  Future<void> clearAllRecoveries() async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.monthlyRecoveryCollections.clear();
    });
  }
}

