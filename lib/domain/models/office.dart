class Office {
  final String id;
  final String branchId;
  final String name;

  const Office({
    required this.id,
    required this.branchId,
    required this.name,
  });

  Office copyWith({
    String? id,
    String? branchId,
    String? name,
  }) {
    return Office(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
    );
  }

  factory Office.fromJson(Map<String, dynamic> json) {
    return Office(
      id: json['id'] as String,
      branchId: (json['branch_id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Office &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          branchId == other.branchId &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ branchId.hashCode ^ name.hashCode;

  @override
  String toString() => 'Office(id: $id, branchId: $branchId, name: $name)';
}

