import 'package:isar_community/isar.dart';
import '../../../core/security/cipher_service.dart';
import '../../../domain/models/loan.dart';

part 'loan_collection.g.dart';

@collection
class LoanCollection {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String customerId;

  late String accountNo;

  String principalOutstandingEncrypted = '';

  String baseEmiAmountEncrypted = '';

  @Index()
  String status = 'Active';

  Loan toDomain([CipherService? cipher]) {
    final outstanding =
        cipher != null && principalOutstandingEncrypted.isNotEmpty
            ? cipher.decryptDouble(principalOutstandingEncrypted)
            : double.tryParse(principalOutstandingEncrypted) ?? 0.0;

    final emi = cipher != null && baseEmiAmountEncrypted.isNotEmpty
        ? cipher.decryptDouble(baseEmiAmountEncrypted)
        : double.tryParse(baseEmiAmountEncrypted) ?? 0.0;

    return Loan(
      id: id,
      customerId: customerId,
      accountNo: cipher?.decryptString(accountNo) ?? accountNo,
      principalOutstanding: outstanding,
      baseEmiAmount: emi,
      status: status,
    );
  }

  static LoanCollection fromDomain(
    Loan loan, [
    CipherService? cipher,
  ]) {
    return LoanCollection()
      ..id = loan.id
      ..customerId = loan.customerId
      ..accountNo = cipher?.encryptString(loan.accountNo) ?? loan.accountNo
      ..principalOutstandingEncrypted =
          cipher?.encryptDouble(loan.principalOutstanding) ??
              loan.principalOutstanding.toString()
      ..baseEmiAmountEncrypted =
          cipher?.encryptDouble(loan.baseEmiAmount) ??
              loan.baseEmiAmount.toString()
      ..status = loan.status;
  }
}
