import '../../domain/models/customer.dart';
import '../../domain/repositories/i_customer_repository.dart';

class InMemoryCustomerRepository implements ICustomerRepository {
  final Map<String, Customer> _storage = {};

  InMemoryCustomerRepository([List<Customer>? initial]) {
    if (initial != null) {
      for (final customer in initial) {
        _storage[customer.id] = customer;
      }
    }
  }

  @override
  Future<List<Customer>> getAllCustomers({String? officeId}) async {
    if (officeId != null) {
      return _storage.values.where((c) => c.officeId == officeId).toList();
    }
    return _storage.values.toList();
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    return _storage[id];
  }

  @override
  Future<Customer> saveCustomer(Customer customer) async {
    _storage[customer.id] = customer;
    return customer;
  }

  @override
  Future<void> deleteCustomer(String id) async {
    _storage.remove(id);
  }

  @override
  Future<void> deleteCustomersByOfficeId(String officeId) async {
    _storage.removeWhere((_, c) => c.officeId == officeId);
  }

  @override
  Future<void> clearAllCustomers() async {
    _storage.clear();
  }
}

