import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cjspoton/screen/order/order_menu_details.dart';
import 'package:cjspoton/screen/order/order_model.dart';

class OrderDetailModel {
  OrderModel order;
  String orderdate;
  String outletname;
  String address;
  List<OrderMenuDetails> menuDetails;
  OrderDetailModel({
    required this.order,
    required this.orderdate,
    required this.outletname,
    required this.address,
    required this.menuDetails,
  });

  OrderDetailModel copyWith({
    OrderModel? order,
    String? orderdate,
    String? outletname,
    String? address,
    List<OrderMenuDetails>? menuDetails,
  }) {
    return OrderDetailModel(
      order: order ?? this.order,
      orderdate: orderdate ?? this.orderdate,
      outletname: outletname ?? this.outletname,
      address: address ?? this.address,
      menuDetails: menuDetails ?? this.menuDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order.toMap(),
      'orderdate': orderdate,
      'outletname': outletname,
      'address': address,
      'menuDetails': menuDetails?.map((x) => x.toMap())?.toList(),
    };
  }

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
      order: OrderModel.fromMap(map['order']),
      orderdate: map['orderdate'],
      outletname: map['outletname'],
      address: map['address'],
      menuDetails: List<OrderMenuDetails>.from(
          map['menuDetails']?.map((x) => OrderMenuDetails.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetailModel.fromJson(String source) =>
      OrderDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderDetailModel(order: $order, orderdate: $orderdate, outletname: $outletname, address: $address, menuDetails: $menuDetails)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderDetailModel &&
        other.order == order &&
        other.orderdate == orderdate &&
        other.outletname == outletname &&
        other.address == address &&
        listEquals(other.menuDetails, menuDetails);
  }

  @override
  int get hashCode {
    return order.hashCode ^
        orderdate.hashCode ^
        outletname.hashCode ^
        address.hashCode ^
        menuDetails.hashCode;
  }
}
