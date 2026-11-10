import '../models/office.dart';

abstract class IOfficeRepository {
  /// Fetches all registered offices/branches.
  Future<List<Office>> getAllOffices();

  /// Fetches an office by its unique ID.
  Future<Office?> getOfficeById(String id);

  /// Saves or creates an office.
  Future<Office> saveOffice(Office office);

  /// Deletes an office by ID.
  Future<void> deleteOffice(String id);

  /// Wipes all offices (useful for resetting/seeding data).
  Future<void> clearAllOffices();
}

