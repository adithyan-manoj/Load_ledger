import 'package:isar_community/isar.dart';
import '../../../core/security/cipher_service.dart';
import '../../../domain/models/customer.dart';

part 'customer_collection.g.dart';

@collection
class CustomerCollection {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String officeId;

  late String memberNo;

  late String name;

  Customer toDomain([CipherService? cipher]) {
    return Customer(
      id: id,
      officeId: officeId,
      memberNo: cipher?.decryptString(memberNo) ?? memberNo,
      name: cipher?.decryptString(name) ?? name,
    );
  }

  static CustomerCollection fromDomain(
    Customer customer, [
    CipherService? cipher,
  ]) {
    return CustomerCollection()
      ..id = customer.id
      ..officeId = customer.officeId
      ..memberNo =
          cipher?.encryptString(customer.memberNo) ?? customer.memberNo
      ..name = cipher?.encryptString(customer.name) ?? customer.name;
  }
}
