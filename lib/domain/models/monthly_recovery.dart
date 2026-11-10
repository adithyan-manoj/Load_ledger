class MonthlyRecovery {
  final String id;
  final String loanId;
  final int month;
  final int year;
  final double principalDue;
  final double interest;
  final double penalInterest;
  final double otherCharges;
  final bool isReviewed;

  const MonthlyRecovery({
    required this.id,
    required this.loanId,
    required this.month,
    required this.year,
    required this.principalDue,
    required this.interest,
    this.penalInterest = 0.0,
    this.otherCharges = 0.0,
    this.isReviewed = false,
  });

  MonthlyRecovery copyWith({
    String? id,
    String? loanId,
    int? month,
    int? year,
    double? principalDue,
    double? interest,
    double? penalInterest,
    double? otherCharges,
    bool? isReviewed,
  }) {
    return MonthlyRecovery(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      month: month ?? this.month,
      year: year ?? this.year,
      principalDue: principalDue ?? this.principalDue,
      interest: interest ?? this.interest,
      penalInterest: penalInterest ?? this.penalInterest,
      otherCharges: otherCharges ?? this.otherCharges,
      isReviewed: isReviewed ?? this.isReviewed,
    );
  }

  factory MonthlyRecovery.fromJson(Map<String, dynamic> json) {
    return MonthlyRecovery(
      id: json['id'] as String,
      loanId: json['loan_id'] as String,
      month: json['month'] as int,
      year: json['year'] as int,
      principalDue: (json['principal_due'] as num?)?.toDouble() ?? 0.0,
      interest: (json['interest'] as num?)?.toDouble() ?? 0.0,
      penalInterest: (json['penal_interest'] as num?)?.toDouble() ?? 0.0,
      otherCharges: (json['other_charges'] as num?)?.toDouble() ?? 0.0,
      isReviewed: (json['is_reviewed'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loan_id': loanId,
      'month': month,
      'year': year,
      'principal_due': principalDue,
      'interest': interest,
      'penal_interest': penalInterest,
      'other_charges': otherCharges,
      'is_reviewed': isReviewed,
    };
  }

  double get totalRecovered =>
      principalDue + interest + penalInterest + otherCharges;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyRecovery &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          loanId == other.loanId &&
          month == other.month &&
          year == other.year &&
          principalDue == other.principalDue &&
          interest == other.interest &&
          penalInterest == other.penalInterest &&
          otherCharges == other.otherCharges &&
          isReviewed == other.isReviewed;

  @override
  int get hashCode =>
      id.hashCode ^
      loanId.hashCode ^
      month.hashCode ^
      year.hashCode ^
      principalDue.hashCode ^
      interest.hashCode ^
      penalInterest.hashCode ^
      otherCharges.hashCode ^
      isReviewed.hashCode;

  @override
  String toString() =>
      'MonthlyRecovery(id: $id, loanId: $loanId, period: $month/$year, principal: $principalDue, interest: $interest, total: $totalRecovered)';
}

