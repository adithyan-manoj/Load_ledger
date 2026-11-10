import '../models/customer.dart';

abstract class ICustomerRepository {
  /// Fetches all registered customers, optionally filtered by officeId.
  Future<List<Customer>> getAllCustomers({String? officeId});

  /// Fetches a customer by their unique ID.
  Future<Customer?> getCustomerById(String id);

  /// Saves or creates a customer.
  Future<Customer> saveCustomer(Customer customer);

  /// Deletes a customer by ID.
  Future<void> deleteCustomer(String id);

  /// Deletes all customers belonging to an office.
  Future<void> deleteCustomersByOfficeId(String officeId);

  /// Wipes all customers (useful for resetting/seeding data).
  Future<void> clearAllCustomers();
}

