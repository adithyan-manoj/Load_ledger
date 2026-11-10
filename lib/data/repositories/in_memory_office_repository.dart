import '../../domain/models/office.dart';
import '../../domain/repositories/i_office_repository.dart';

class InMemoryOfficeRepository implements IOfficeRepository {
  final Map<String, Office> _storage = {};

  InMemoryOfficeRepository([List<Office>? initial]) {
    if (initial != null) {
      for (final office in initial) {
        _storage[office.id] = office;
      }
    }
  }

  @override
  Future<List<Office>> getAllOffices() async {
    return _storage.values.toList();
  }

  @override
  Future<Office?> getOfficeById(String id) async {
    return _storage[id];
  }

  @override
  Future<Office> saveOffice(Office office) async {
    _storage[office.id] = office;
    return office;
  }

  @override
  Future<void> deleteOffice(String id) async {
    _storage.remove(id);
  }

  @override
  Future<void> clearAllOffices() async {
    _storage.clear();
  }
}

