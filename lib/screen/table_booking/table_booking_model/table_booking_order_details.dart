import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_menu_details.dart';

class TableBookingOrderDetails {
  String datetime;
  String ordertype;
  String orderstatus;
  String totalamount;
  String tableno;
  String noguest;
  String outletname;
  List<TableBookingMenuDetails> menuDetailsList;
  TableBookingOrderDetails({
    required this.datetime,
    required this.ordertype,
    required this.orderstatus,
    required this.totalamount,
    required this.tableno,
    required this.noguest,
    required this.outletname,
    required this.menuDetailsList,
  });

  TableBookingOrderDetails copyWith({
    String? datetime,
    String? ordertype,
    String? orderstatus,
    String? totalamount,
    String? tableno,
    String? noguest,
    String? outletname,
    List<TableBookingMenuDetails>? menuDetailsList,
  }) {
    return TableBookingOrderDetails(
      datetime: datetime ?? this.datetime,
      ordertype: ordertype ?? this.ordertype,
      orderstatus: orderstatus ?? this.orderstatus,
      totalamount: totalamount ?? this.totalamount,
      tableno: tableno ?? this.tableno,
      noguest: noguest ?? this.noguest,
      outletname: outletname ?? this.outletname,
      menuDetailsList: menuDetailsList ?? this.menuDetailsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'datetime': datetime,
      'ordertype': ordertype,
      'orderstatus': orderstatus,
      'totalamount': totalamount,
      'tableno': tableno,
      'noguest': noguest,
      'outletname': outletname,
      'menuDetailsList': menuDetailsList.map((x) => x.toMap()).toList(),
    };
  }

  factory TableBookingOrderDetails.fromMap(Map<String, dynamic> map) {
    return TableBookingOrderDetails(
      datetime: map['datetime'],
      ordertype: map['ordertype'],
      orderstatus: map['orderstatus'],
      totalamount: map['totalamount'],
      tableno: map['tableno'],
      noguest: map['noguest'],
      outletname: map['outletname'],
      menuDetailsList: List<TableBookingMenuDetails>.from(map['menuDetailsList']
          ?.map((x) => TableBookingMenuDetails.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TableBookingOrderDetails.fromJson(String source) =>
      TableBookingOrderDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TableBookingOrderDetails(datetime: $datetime, ordertype: $ordertype, orderstatus: $orderstatus, totalamount: $totalamount, tableno: $tableno, noguest: $noguest, outletname: $outletname, menuDetailsList: $menuDetailsList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableBookingOrderDetails &&
        other.datetime == datetime &&
        other.ordertype == ordertype &&
        other.orderstatus == orderstatus &&
        other.totalamount == totalamount &&
        other.tableno == tableno &&
        other.noguest == noguest &&
        other.outletname == outletname &&
        listEquals(other.menuDetailsList, menuDetailsList);
  }

  @override
  int get hashCode {
    return datetime.hashCode ^
        ordertype.hashCode ^
        orderstatus.hashCode ^
        totalamount.hashCode ^
        tableno.hashCode ^
        noguest.hashCode ^
        outletname.hashCode ^
        menuDetailsList.hashCode;
  }
}
