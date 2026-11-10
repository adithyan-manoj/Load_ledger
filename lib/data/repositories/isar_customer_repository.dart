import 'package:isar_community/isar.dart';
import '../../core/security/cipher_service.dart';
import '../../domain/models/customer.dart';
import '../../domain/repositories/i_customer_repository.dart';
import '../local/isar_database_service.dart';
import '../local/schemas/customer_collection.dart';

class IsarCustomerRepository implements ICustomerRepository {
  final IsarDatabaseService dbService;
  final CipherService? cipherService;

  IsarCustomerRepository({
    required this.dbService,
    this.cipherService,
  });

  @override
  Future<List<Customer>> getAllCustomers({String? officeId}) async {
    final isar = await dbService.isar;
    final List<CustomerCollection> collections;
    if (officeId != null) {
      collections = await isar.customerCollections
          .filter()
          .officeIdEqualTo(officeId)
          .findAll();
    } else {
      collections = await isar.customerCollections.where().findAll();
    }
    return collections.map((c) => c.toDomain(cipherService)).toList();
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    final isar = await dbService.isar;
    final collection =
        await isar.customerCollections.filter().idEqualTo(id).findFirst();
    return collection?.toDomain(cipherService);
  }

  @override
  Future<Customer> saveCustomer(Customer customer) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      final existing = await isar.customerCollections
          .filter()
          .idEqualTo(customer.id)
          .findFirst();
      final collection = CustomerCollection.fromDomain(customer, cipherService);
      if (existing != null) {
        collection.isarId = existing.isarId;
      }
      await isar.customerCollections.put(collection);
    });
    return customer;
  }

  @override
  Future<void> deleteCustomer(String id) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.customerCollections.filter().idEqualTo(id).deleteAll();
    });
  }

  @override
  Future<void> deleteCustomersByOfficeId(String officeId) async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.customerCollections
          .filter()
          .officeIdEqualTo(officeId)
          .deleteAll();
    });
  }

  @override
  Future<void> clearAllCustomers() async {
    final isar = await dbService.isar;
    await isar.writeTxn(() async {
      await isar.customerCollections.clear();
    });
  }
}
