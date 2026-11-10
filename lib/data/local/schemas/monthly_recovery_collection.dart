import 'package:isar_community/isar.dart';
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

  double principalDue = 0.0;

  double interest = 0.0;

  double penalInterest = 0.0;

  double otherCharges = 0.0;

  bool isReviewed = false;

  MonthlyRecovery toDomain() {
    return MonthlyRecovery(
      id: id,
      loanId: loanId,
      month: month,
      year: year,
      principalDue: principalDue,
      interest: interest,
      penalInterest: penalInterest,
      otherCharges: otherCharges,
      isReviewed: isReviewed,
    );
  }

  static MonthlyRecoveryCollection fromDomain(MonthlyRecovery recovery) {
    return MonthlyRecoveryCollection()
      ..id = recovery.id
      ..loanId = recovery.loanId
      ..month = recovery.month
      ..year = recovery.year
      ..principalDue = recovery.principalDue
      ..interest = recovery.interest
      ..penalInterest = recovery.penalInterest
      ..otherCharges = recovery.otherCharges
      ..isReviewed = recovery.isReviewed;
  }
}

