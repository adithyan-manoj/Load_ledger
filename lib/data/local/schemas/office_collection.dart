import 'package:isar_community/isar.dart';
import '../../../core/security/cipher_service.dart';
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

  Office toDomain([CipherService? cipher]) {
    return Office(
      id: id,
      branchId: branchId,
      name: cipher?.decryptString(name) ?? name,
    );
  }

  static OfficeCollection fromDomain(
    Office office, [
    CipherService? cipher,
  ]) {
    return OfficeCollection()
      ..id = office.id
      ..branchId = office.branchId
      ..name = cipher?.encryptString(office.name) ?? office.name;
  }
}
