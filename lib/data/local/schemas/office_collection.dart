import 'package:isar_community/isar.dart';
import '../../../domain/models/office.dart';

part 'office_collection.g.dart';

@collection
class OfficeCollection {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String branchId;

  late String name;

  Office toDomain() {
    return Office(
      id: id,
      branchId: branchId,
      name: name,
    );
  }

  static OfficeCollection fromDomain(Office office) {
    return OfficeCollection()
      ..id = office.id
      ..branchId = office.branchId
      ..name = office.name;
  }
}

