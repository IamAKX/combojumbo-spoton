import 'dart:convert';

import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/coupon_discount_detail_model.dart';
import 'package:cjspoton/model/pincode_model.dart';

class CartVriablesModel {
  AllChargesModel? allChargesModel;
  PincodeModel selectedPincode;
  CouponDiscountDetailModel? couponDiscountDetailModel;
  double netAmount;
  CartVriablesModel({
    this.allChargesModel,
    required this.selectedPincode,
    this.couponDiscountDetailModel,
    required this.netAmount,
  });

  CartVriablesModel copyWith({
    AllChargesModel? allChargesModel,
    PincodeModel? selectedPincode,
    CouponDiscountDetailModel? couponDiscountDetailModel,
    double? netAmount,
  }) {
    return CartVriablesModel(
      allChargesModel: allChargesModel ?? this.allChargesModel,
      selectedPincode: selectedPincode ?? this.selectedPincode,
      couponDiscountDetailModel:
          couponDiscountDetailModel ?? this.couponDiscountDetailModel,
      netAmount: netAmount ?? this.netAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allChargesModel': allChargesModel?.toMap(),
      'selectedPincode': selectedPincode.toMap(),
      'couponDiscountDetailModel': couponDiscountDetailModel?.toMap(),
      'netAmount': netAmount,
    };
  }

  factory CartVriablesModel.fromMap(Map<String, dynamic> map) {
    return CartVriablesModel(
      allChargesModel: AllChargesModel.fromMap(map['allChargesModel']),
      selectedPincode: PincodeModel.fromMap(map['selectedPincode']),
      couponDiscountDetailModel:
          CouponDiscountDetailModel.fromMap(map['couponDiscountDetailModel']),
      netAmount: map['netAmount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartVriablesModel.fromJson(String source) =>
      CartVriablesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartVriablesModel(allChargesModel: $allChargesModel, selectedPincode: $selectedPincode, couponDiscountDetailModel: $couponDiscountDetailModel, netAmount: $netAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartVriablesModel &&
        other.allChargesModel == allChargesModel &&
        other.selectedPincode == selectedPincode &&
        other.couponDiscountDetailModel == couponDiscountDetailModel &&
        other.netAmount == netAmount;
  }

  @override
  int get hashCode {
    return allChargesModel.hashCode ^
        selectedPincode.hashCode ^
        couponDiscountDetailModel.hashCode ^
        netAmount.hashCode;
  }
}
