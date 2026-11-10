import 'package:isar_community/isar.dart';
import '../../../domain/models/customer.dart';

part 'customer_collection.g.dart';

@collection
class CustomerCollection {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String officeId;

  @Index()
  late String memberNo;

  late String name;

  Customer toDomain() {
    return Customer(
      id: id,
      officeId: officeId,
      memberNo: memberNo,
      name: name,
    );
  }

  static CustomerCollection fromDomain(Customer customer) {
    return CustomerCollection()
      ..id = customer.id
      ..officeId = customer.officeId
      ..memberNo = customer.memberNo
      ..name = customer.name;
  }
}

