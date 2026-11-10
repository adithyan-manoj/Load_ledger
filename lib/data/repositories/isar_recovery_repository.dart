import 'package:isar_community/isar.dart';
import '../../core/security/cipher_service.dart';
import '../../domain/models/monthly_recovery.dart';
import '../../domain/repositories/i_recovery_repository.dart';
import '../local/isar_database_service.dart';
import '../local/schemas/monthly_recovery_collection.dart';

class IsarRecoveryRepository implements IRecoveryRepository {
  final IsarDatabaseService dbService;
  final CipherService? cipherService;

  IsarRecoveryRepository({
    required this.dbService,
    this.cipherService,
  });

  @override
  Future<List<MonthlyRecovery>> getRecoveries({
    int? month,
    int? year,
    List<String>? loanIds,
  }) async {
    final isar = await dbService.isar;

    if (month == null && year == null && (loanIds == null || loanIds.isEmpty)) {
      final all = await isar.monthlyRecoveryCollections.where().findAll();
      return all.map((c) => c.toDomain(cipherService)).toList();
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

    return collections.map((c) => c.toDomain(cipherService)).toList();
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

    return collection?.toDomain(cipherService);
  }

  @override
  Future<MonthlyRecovery?> getRecoveryById(String id) async {
    final isar = await dbService.isar;
    final collection = await isar.monthlyRecoveryCollections
        .filter()
        .idEqualTo(id)
        .findFirst();

    return collection?.toDomain(cipherService);
  }

  Future<List<MonthlyRecovery>> getRecoveriesByMonthAndYear(
    int month,
    int year,
  ) async {
    final isar = await dbService.isar;
    final collections = await isar.monthlyRecoveryCollections
        .filter()
        .monthEqualTo(month)
        .and()
        .yearEqualTo(year)
        .findAll();

    return collections.map((c) => c.toDomain(cipherService)).toList();
  }

  Future<List<MonthlyRecovery>> getUnreviewedRecoveries() async {
    final isar = await dbService.isar;
    final collections = await isar.monthlyRecoveryCollections
        .filter()
        .isReviewedEqualTo(false)
        .findAll();

    return collections.map((c) => c.toDomain(cipherService)).toList();
  }

  @override
  Future<MonthlyRecovery> saveRecovery(MonthlyRecovery recovery) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      final existing = await isar.monthlyRecoveryCollections
          .filter()
          .idEqualTo(recovery.id)
          .findFirst();
      final collection =
          MonthlyRecoveryCollection.fromDomain(recovery, cipherService);
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
        final collection =
            MonthlyRecoveryCollection.fromDomain(r, cipherService);
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

  Future<void> updateRecoveryAmounts({
    required String id,
    double? principalDue,
    double? interest,
    double? penalInterest,
    double? otherCharges,
    bool? isReviewed,
  }) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      final collection = await isar.monthlyRecoveryCollections
          .filter()
          .idEqualTo(id)
          .findFirst();

      if (collection != null) {
        if (principalDue != null) {
          collection.principalDueEncrypted = cipherService != null
              ? cipherService!.encryptDouble(principalDue)
              : principalDue.toString();
        }
        if (interest != null) {
          collection.interestEncrypted = cipherService != null
              ? cipherService!.encryptDouble(interest)
              : interest.toString();
        }
        if (penalInterest != null) {
          collection.penalInterestEncrypted = cipherService != null
              ? cipherService!.encryptDouble(penalInterest)
              : penalInterest.toString();
        }
        if (otherCharges != null) {
          collection.otherChargesEncrypted = cipherService != null
              ? cipherService!.encryptDouble(otherCharges)
              : otherCharges.toString();
        }
        if (isReviewed != null) {
          collection.isReviewed = isReviewed;
        }

        await isar.monthlyRecoveryCollections.put(collection);
      }
    });
  }

  @override
  Future<void> deleteRecovery(String id) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.monthlyRecoveryCollections.filter().idEqualTo(id).deleteAll();
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

  Future<void> deleteRecoveriesByLoanIds(List<String> loanIds) async {
    if (loanIds.isEmpty) return;
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.monthlyRecoveryCollections
          .filter()
          .anyOf(loanIds, (q, String lid) => q.loanIdEqualTo(lid))
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
