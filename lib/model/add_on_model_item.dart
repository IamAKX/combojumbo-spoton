import 'dart:convert';

class AddOnItemModel {
  String id;
  String subaddonsname;
  String amount;
  AddOnItemModel({
    required this.id,
    required this.subaddonsname,
    required this.amount,
  });

  AddOnItemModel copyWith({
    String? id,
    String? subaddonsname,
    String? amount,
  }) {
    return AddOnItemModel(
      id: id ?? this.id,
      subaddonsname: subaddonsname ?? this.subaddonsname,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subaddonsname': subaddonsname,
      'amount': amount,
    };
  }

  factory AddOnItemModel.fromMap(Map<String, dynamic> map) {
    return AddOnItemModel(
      id: map['id'],
      subaddonsname: map['subaddonsname'],
      amount: map['amount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddOnItemModel.fromJson(String source) =>
      AddOnItemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AddOnItemModel(id: $id, subaddonsname: $subaddonsname, amount: $amount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddOnItemModel &&
        other.id == id &&
        other.subaddonsname == subaddonsname &&
        other.amount == amount;
  }

  @override
  int get hashCode => id.hashCode ^ subaddonsname.hashCode ^ amount.hashCode;
}
