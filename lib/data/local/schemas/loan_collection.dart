import 'package:isar_community/isar.dart';
import '../../../domain/models/loan.dart';

part 'loan_collection.g.dart';

@collection
class LoanCollection {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String customerId;

  @Index()
  late String accountNo;

  double principalOutstanding = 0.0;

  double baseEmiAmount = 0.0;

  @Index()
  String status = 'Active';

  Loan toDomain() {
    return Loan(
      id: id,
      customerId: customerId,
      accountNo: accountNo,
      principalOutstanding: principalOutstanding,
      baseEmiAmount: baseEmiAmount,
      status: status,
    );
  }

  static LoanCollection fromDomain(Loan loan) {
    return LoanCollection()
      ..id = loan.id
      ..customerId = loan.customerId
      ..accountNo = loan.accountNo
      ..principalOutstanding = loan.principalOutstanding
      ..baseEmiAmount = loan.baseEmiAmount
      ..status = loan.status;
  }
}

