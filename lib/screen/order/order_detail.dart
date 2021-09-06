import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cjspoton/screen/order/order_menu_details.dart';
import 'package:cjspoton/screen/order/order_model.dart';

class OrderDetailModel {
  OrderModel order;
  String outletname;
  List<OrderMenuDetails> menuDetails;
  OrderDetailModel({
    required this.order,
    required this.outletname,
    required this.menuDetails,
  });

  OrderDetailModel copyWith({
    OrderModel? order,
    String? outletname,
    List<OrderMenuDetails>? menuDetails,
  }) {
    return OrderDetailModel(
      order: order ?? this.order,
      outletname: outletname ?? this.outletname,
      menuDetails: menuDetails ?? this.menuDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order.toMap(),
      'outletname': outletname,
      'menuDetails': menuDetails.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
      order: OrderModel.fromMap(map['order']),
      outletname: map['outletname'],
      menuDetails: List<OrderMenuDetails>.from(
          map['menuDetails']?.map((x) => OrderMenuDetails.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetailModel.fromJson(String source) =>
      OrderDetailModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'OrderDetailModel(order: $order, outletname: $outletname, menuDetails: $menuDetails)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderDetailModel &&
        other.order == order &&
        other.outletname == outletname &&
        listEquals(other.menuDetails, menuDetails);
  }

  @override
  int get hashCode =>
      order.hashCode ^ outletname.hashCode ^ menuDetails.hashCode;
}
