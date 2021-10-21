import 'dart:convert';

class CouponModel {
  String Id;
  String code;
  String description;
  CouponModel({
    required this.Id,
    required this.code,
    required this.description,
  });

  CouponModel copyWith({
    String? Id,
    String? code,
    String? description,
  }) {
    return CouponModel(
      Id: Id ?? this.Id,
      code: code ?? this.code,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'code': code,
      'description': description,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      Id: map['Id'],
      code: map['code'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) =>
      CouponModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CouponModel(Id: $Id, code: $code, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CouponModel &&
        other.Id == Id &&
        other.code == code &&
        other.description == description;
  }

  @override
  int get hashCode => Id.hashCode ^ code.hashCode ^ description.hashCode;
}
