import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cjspoton/model/offer_item.dart';

class OfferModel {
  int? status;
  int? msg;
  List<OfferItemModel>? data;
  String? coupon_image;
  OfferModel({
    this.status,
    this.msg,
    this.data,
    this.coupon_image,
  });

  OfferModel copyWith({
    int? status,
    int? msg,
    List<OfferItemModel>? data,
    String? coupon_image,
  }) {
    return OfferModel(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      data: data ?? this.data,
      coupon_image: coupon_image ?? this.coupon_image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'msg': msg,
      'data': data?.map((x) => x.toMap()).toList(),
      'coupon_image': coupon_image,
    };
  }

  factory OfferModel.fromMap(Map<String, dynamic> map) {
    return OfferModel(
      status: map['status'] != null ? map['status'] : null,
      msg: map['msg'] != null ? map['msg'] : null,
      data: map['data'] != null
          ? List<OfferItemModel>.from(
              map['data']?.map((x) => OfferItemModel.fromMap(x)))
          : null,
      coupon_image: map['coupon_image'] != null ? map['coupon_image'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferModel.fromJson(String source) =>
      OfferModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OfferModel(status: $status, msg: $msg, data: $data, coupon_image: $coupon_image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OfferModel &&
        other.status == status &&
        other.msg == msg &&
        listEquals(other.data, data) &&
        other.coupon_image == coupon_image;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        msg.hashCode ^
        data.hashCode ^
        coupon_image.hashCode;
  }
}
