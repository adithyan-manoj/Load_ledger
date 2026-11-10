import 'package:isar_community/isar.dart';
import '../../core/security/cipher_service.dart';
import '../../domain/models/loan.dart';
import '../../domain/repositories/i_loan_repository.dart';
import '../local/isar_database_service.dart';
import '../local/schemas/loan_collection.dart';

class IsarLoanRepository implements ILoanRepository {
  final IsarDatabaseService dbService;
  final CipherService? cipherService;

  IsarLoanRepository({
    required this.dbService,
    this.cipherService,
  });

  @override
  Future<List<Loan>> getAllLoans({
    String? customerId,
    List<String>? statuses,
  }) async {
    final isar = await dbService.isar;
    final List<LoanCollection> collections;

    if (customerId != null || (statuses != null && statuses.isNotEmpty)) {
      collections = await isar.loanCollections
          .filter()
          .optional(
            customerId != null,
            (q) => q.customerIdEqualTo(customerId!),
          )
          .optional(
            statuses != null && statuses.isNotEmpty,
            (q) => q.anyOf(statuses!,
                (q2, String status) => q2.statusEqualTo(status)),
          )
          .findAll();
    } else {
      collections = await isar.loanCollections.where().findAll();
    }

    return collections.map((c) => c.toDomain(cipherService)).toList();
  }

  @override
  Future<List<Loan>> getLoansByCustomerIds(
    List<String> customerIds, {
    List<String>? statuses,
  }) async {
    if (customerIds.isEmpty) return [];
    final isar = await dbService.isar;

    final collections = await isar.loanCollections
        .filter()
        .anyOf(customerIds, (q, String cid) => q.customerIdEqualTo(cid))
        .optional(
          statuses != null && statuses.isNotEmpty,
          (q) => q.anyOf(
              statuses!, (q2, String status) => q2.statusEqualTo(status)),
        )
        .findAll();

    return collections.map((c) => c.toDomain(cipherService)).toList();
  }

  @override
  Future<Loan?> getLoanById(String id) async {
    final isar = await dbService.isar;
    final collection =
        await isar.loanCollections.filter().idEqualTo(id).findFirst();
    return collection?.toDomain(cipherService);
  }

  @override
  Future<Loan> saveLoan(Loan loan) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      final existing =
          await isar.loanCollections.filter().idEqualTo(loan.id).findFirst();
      final collection = LoanCollection.fromDomain(loan, cipherService);
      if (existing != null) {
        collection.isarId = existing.isarId;
      }
      await isar.loanCollections.put(collection);
    });
    return loan;
  }

  Future<void> saveLoans(List<Loan> loans) async {
    if (loans.isEmpty) return;
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      final collections = <LoanCollection>[];
      for (final loan in loans) {
        final existing =
            await isar.loanCollections.filter().idEqualTo(loan.id).findFirst();
        final collection = LoanCollection.fromDomain(loan, cipherService);
        if (existing != null) {
          collection.isarId = existing.isarId;
        }
        collections.add(collection);
      }
      await isar.loanCollections.putAll(collections);
    });
  }

  @override
  Future<void> deleteLoan(String id) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.loanCollections.filter().idEqualTo(id).deleteAll();
    });
  }

  @override
  Future<void> deleteLoansByCustomerId(String customerId) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.loanCollections
          .filter()
          .customerIdEqualTo(customerId)
          .deleteAll();
    });
  }

  Future<void> deleteLoansByCustomerIds(List<String> customerIds) async {
    if (customerIds.isEmpty) return;
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.loanCollections
          .filter()
          .anyOf(customerIds, (q, String cid) => q.customerIdEqualTo(cid))
          .deleteAll();
    });
  }

  @override
  Future<void> clearAllLoans() async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.loanCollections.clear();
    });
  }
}
