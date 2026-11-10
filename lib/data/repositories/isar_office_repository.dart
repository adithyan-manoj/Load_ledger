import 'package:isar_community/isar.dart';
import '../../core/security/cipher_service.dart';
import '../../domain/models/office.dart';
import '../../domain/repositories/i_office_repository.dart';
import '../local/isar_database_service.dart';
import '../local/schemas/office_collection.dart';

class IsarOfficeRepository implements IOfficeRepository {
  final IsarDatabaseService dbService;
  final CipherService? cipherService;

  IsarOfficeRepository({
    required this.dbService,
    this.cipherService,
  });

  @override
  Future<List<Office>> getAllOffices() async {
    final isar = await dbService.isar;
    final collections = await isar.officeCollections.where().findAll();
    return collections.map((c) => c.toDomain(cipherService)).toList();
  }

  @override
  Future<Office?> getOfficeById(String id) async {
    final isar = await dbService.isar;
    final collection =
        await isar.officeCollections.filter().idEqualTo(id).findFirst();
    return collection?.toDomain(cipherService);
  }

  @override
  Future<Office> saveOffice(Office office) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      final existing =
          await isar.officeCollections.filter().idEqualTo(office.id).findFirst();
      final collection = OfficeCollection.fromDomain(office, cipherService);
      if (existing != null) {
        collection.isarId = existing.isarId;
      }
      await isar.officeCollections.put(collection);
    });
    return office;
  }

  @override
  Future<void> deleteOffice(String id) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.officeCollections.filter().idEqualTo(id).deleteAll();
    });
  }

  @override
  Future<void> clearAllOffices() async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.officeCollections.clear();
    });
  }
}
