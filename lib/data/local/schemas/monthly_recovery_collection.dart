import 'package:isar_community/isar.dart';
import '../../../core/security/cipher_service.dart';
import '../../../domain/models/monthly_recovery.dart';

part 'monthly_recovery_collection.g.dart';

@collection
class MonthlyRecoveryCollection {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index(composite: [CompositeIndex('month'), CompositeIndex('year')])
  late String loanId;

  int month = 1;

  @Index(composite: [CompositeIndex('month')])
  int year = 2026;

  String principalDueEncrypted = '';

  String interestEncrypted = '';

  String penalInterestEncrypted = '';

  String otherChargesEncrypted = '';

  bool isReviewed = false;

  MonthlyRecovery toDomain([CipherService? cipher]) {
    final pDue = cipher != null && principalDueEncrypted.isNotEmpty
        ? cipher.decryptDouble(principalDueEncrypted)
        : double.tryParse(principalDueEncrypted) ?? 0.0;

    final intVal = cipher != null && interestEncrypted.isNotEmpty
        ? cipher.decryptDouble(interestEncrypted)
        : double.tryParse(interestEncrypted) ?? 0.0;

    final penalVal = cipher != null && penalInterestEncrypted.isNotEmpty
        ? cipher.decryptDouble(penalInterestEncrypted)
        : double.tryParse(penalInterestEncrypted) ?? 0.0;

    final othersVal = cipher != null && otherChargesEncrypted.isNotEmpty
        ? cipher.decryptDouble(otherChargesEncrypted)
        : double.tryParse(otherChargesEncrypted) ?? 0.0;

    return MonthlyRecovery(
      id: id,
      loanId: loanId,
      month: month,
      year: year,
      principalDue: pDue,
      interest: intVal,
      penalInterest: penalVal,
      otherCharges: othersVal,
      isReviewed: isReviewed,
    );
  }

  static MonthlyRecoveryCollection fromDomain(
    MonthlyRecovery recovery, [
    CipherService? cipher,
  ]) {
    return MonthlyRecoveryCollection()
      ..id = recovery.id
      ..loanId = recovery.loanId
      ..month = recovery.month
      ..year = recovery.year
      ..principalDueEncrypted =
          cipher?.encryptDouble(recovery.principalDue) ??
              recovery.principalDue.toString()
      ..interestEncrypted = cipher?.encryptDouble(recovery.interest) ??
          recovery.interest.toString()
      ..penalInterestEncrypted =
          cipher?.encryptDouble(recovery.penalInterest) ??
              recovery.penalInterest.toString()
      ..otherChargesEncrypted =
          cipher?.encryptDouble(recovery.otherCharges) ??
              recovery.otherCharges.toString()
      ..isReviewed = recovery.isReviewed;
  }
}
