class Loan {
  final String id;
  final String customerId;
  final String accountNo;
  final double principalOutstanding;
  final double baseEmiAmount;
  final String status;

  const Loan({
    required this.id,
    required this.customerId,
    required this.accountNo,
    required this.principalOutstanding,
    required this.baseEmiAmount,
    this.status = 'Active',
  });

  Loan copyWith({
    String? id,
    String? customerId,
    String? accountNo,
    double? principalOutstanding,
    double? baseEmiAmount,
    String? status,
  }) {
    return Loan(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      accountNo: accountNo ?? this.accountNo,
      principalOutstanding: principalOutstanding ?? this.principalOutstanding,
      baseEmiAmount: baseEmiAmount ?? this.baseEmiAmount,
      status: status ?? this.status,
    );
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      accountNo: json['account_no'] as String,
      principalOutstanding:
          (json['principal_outstanding'] as num?)?.toDouble() ?? 0.0,
      baseEmiAmount: (json['base_emi_amount'] as num?)?.toDouble() ?? 0.0,
      status: (json['status'] as String?) ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'account_no': accountNo,
      'principal_outstanding': principalOutstanding,
      'base_emi_amount': baseEmiAmount,
      'status': status,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Loan &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          customerId == other.customerId &&
          accountNo == other.accountNo &&
          principalOutstanding == other.principalOutstanding &&
          baseEmiAmount == other.baseEmiAmount &&
          status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      customerId.hashCode ^
      accountNo.hashCode ^
      principalOutstanding.hashCode ^
      baseEmiAmount.hashCode ^
      status.hashCode;

  @override
  String toString() =>
      'Loan(id: $id, customerId: $customerId, accountNo: $accountNo, outstanding: $principalOutstanding, baseEmi: $baseEmiAmount, status: $status)';
}

