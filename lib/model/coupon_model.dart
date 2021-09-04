import 'dart:convert';

class CouponModel {
  String Id;
  String code;
  CouponModel({
    required this.Id,
    required this.code,
  });

  CouponModel copyWith({
    String? Id,
    String? code,
  }) {
    return CouponModel(
      Id: Id ?? this.Id,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'code': code,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      Id: map['Id'],
      code: map['code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponModel.fromJson(String source) =>
      CouponModel.fromMap(json.decode(source));

  @override
  String toString() => 'CouponModel(Id: $Id, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CouponModel && other.Id == Id && other.code == code;
  }

  @override
  int get hashCode => Id.hashCode ^ code.hashCode;
}
