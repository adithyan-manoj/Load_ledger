class Customer {
  final String id;
  final String officeId;
  final String memberNo;
  final String name;

  const Customer({
    required this.id,
    required this.officeId,
    required this.memberNo,
    required this.name,
  });

  Customer copyWith({
    String? id,
    String? officeId,
    String? memberNo,
    String? name,
  }) {
    return Customer(
      id: id ?? this.id,
      officeId: officeId ?? this.officeId,
      memberNo: memberNo ?? this.memberNo,
      name: name ?? this.name,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      officeId: json['office_id'] as String,
      memberNo: json['member_no'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'office_id': officeId,
      'member_no': memberNo,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          officeId == other.officeId &&
          memberNo == other.memberNo &&
          name == other.name;

  @override
  int get hashCode =>
      id.hashCode ^ officeId.hashCode ^ memberNo.hashCode ^ name.hashCode;

  @override
  String toString() =>
      'Customer(id: $id, officeId: $officeId, memberNo: $memberNo, name: $name)';
}

