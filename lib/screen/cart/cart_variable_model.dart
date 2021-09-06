import 'dart:convert';

import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/coupon_discount_detail_model.dart';
import 'package:cjspoton/model/pincode_model.dart';

class CartVriablesModel {
  AllChargesModel? allChargesModel;
  PincodeModel selectedPincode;
  CouponDiscountDetailModel? couponDiscountDetailModel;
  double netAmount;
  String deliverySuggestion;
  CartVriablesModel({
    this.allChargesModel,
    required this.selectedPincode,
    this.couponDiscountDetailModel,
    required this.netAmount,
    required this.deliverySuggestion,
  });

  CartVriablesModel copyWith({
    AllChargesModel? allChargesModel,
    PincodeModel? selectedPincode,
    CouponDiscountDetailModel? couponDiscountDetailModel,
    double? netAmount,
    String? deliverySuggestion,
  }) {
    return CartVriablesModel(
      allChargesModel: allChargesModel ?? this.allChargesModel,
      selectedPincode: selectedPincode ?? this.selectedPincode,
      couponDiscountDetailModel:
          couponDiscountDetailModel ?? this.couponDiscountDetailModel,
      netAmount: netAmount ?? this.netAmount,
      deliverySuggestion: deliverySuggestion ?? this.deliverySuggestion,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allChargesModel': allChargesModel?.toMap(),
      'selectedPincode': selectedPincode.toMap(),
      'couponDiscountDetailModel': couponDiscountDetailModel?.toMap(),
      'netAmount': netAmount,
      'deliverySuggestion': deliverySuggestion,
    };
  }

  factory CartVriablesModel.fromMap(Map<String, dynamic> map) {
    return CartVriablesModel(
      allChargesModel: AllChargesModel.fromMap(map['allChargesModel']),
      selectedPincode: PincodeModel.fromMap(map['selectedPincode']),
      couponDiscountDetailModel:
          CouponDiscountDetailModel.fromMap(map['couponDiscountDetailModel']),
      netAmount: map['netAmount'],
      deliverySuggestion: map['deliverySuggestion'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartVriablesModel.fromJson(String source) =>
      CartVriablesModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartVriablesModel(allChargesModel: $allChargesModel, selectedPincode: $selectedPincode, couponDiscountDetailModel: $couponDiscountDetailModel, netAmount: $netAmount, deliverySuggestion: $deliverySuggestion)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartVriablesModel &&
        other.allChargesModel == allChargesModel &&
        other.selectedPincode == selectedPincode &&
        other.couponDiscountDetailModel == couponDiscountDetailModel &&
        other.netAmount == netAmount &&
        other.deliverySuggestion == deliverySuggestion;
  }

  @override
  int get hashCode {
    return allChargesModel.hashCode ^
        selectedPincode.hashCode ^
        couponDiscountDetailModel.hashCode ^
        netAmount.hashCode ^
        deliverySuggestion.hashCode;
  }
}
