import 'dart:convert';

class CouponDiscountDetailModel {
  String coupon_code;
  String coupon_type;
  String coupon_value;
  String coupon_id;
  String minimum_order_value;
  String maximum_order_value;
  String no_times;
  CouponDiscountDetailModel({
    required this.coupon_code,
    required this.coupon_type,
    required this.coupon_value,
    required this.coupon_id,
    required this.minimum_order_value,
    required this.maximum_order_value,
    required this.no_times,
  });

  CouponDiscountDetailModel copyWith({
    String? coupon_code,
    String? coupon_type,
    String? coupon_value,
    String? coupon_id,
    String? minimum_order_value,
    String? maximum_order_value,
    String? no_times,
  }) {
    return CouponDiscountDetailModel(
      coupon_code: coupon_code ?? this.coupon_code,
      coupon_type: coupon_type ?? this.coupon_type,
      coupon_value: coupon_value ?? this.coupon_value,
      coupon_id: coupon_id ?? this.coupon_id,
      minimum_order_value: minimum_order_value ?? this.minimum_order_value,
      maximum_order_value: maximum_order_value ?? this.maximum_order_value,
      no_times: no_times ?? this.no_times,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'coupon_code': coupon_code,
      'coupon_type': coupon_type,
      'coupon_value': coupon_value,
      'coupon_id': coupon_id,
      'minimum_order_value': minimum_order_value,
      'maximum_order_value': maximum_order_value,
      'no_times': no_times,
    };
  }

  factory CouponDiscountDetailModel.fromMap(Map<String, dynamic> map) {
    return CouponDiscountDetailModel(
      coupon_code: map['coupon_code'],
      coupon_type: map['coupon_type'],
      coupon_value: map['coupon_value'],
      coupon_id: map['coupon_id'],
      minimum_order_value: map['minimum_order_value'],
      maximum_order_value: map['maximum_order_value'],
      no_times: map['no_times'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CouponDiscountDetailModel.fromJson(String source) =>
      CouponDiscountDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CouponDiscountDetailModel(coupon_code: $coupon_code, coupon_type: $coupon_type, coupon_value: $coupon_value, coupon_id: $coupon_id, minimum_order_value: $minimum_order_value, maximum_order_value: $maximum_order_value, no_times: $no_times)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CouponDiscountDetailModel &&
        other.coupon_code == coupon_code &&
        other.coupon_type == coupon_type &&
        other.coupon_value == coupon_value &&
        other.coupon_id == coupon_id &&
        other.minimum_order_value == minimum_order_value &&
        other.maximum_order_value == maximum_order_value &&
        other.no_times == no_times;
  }

  @override
  int get hashCode {
    return coupon_code.hashCode ^
        coupon_type.hashCode ^
        coupon_value.hashCode ^
        coupon_id.hashCode ^
        minimum_order_value.hashCode ^
        maximum_order_value.hashCode ^
        no_times.hashCode;
  }
}
