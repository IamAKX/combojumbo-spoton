import 'dart:convert';

import 'package:cjspoton/model/add_on_model_item.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String foodname;
  String fooddescription;
  String foodamount;
  String fooddiscountamount;
  String foodid;
  String foodcode;
  String foodImage;
  List<AddOnItemModel> addOns;
  CartItem({
    required this.id,
    required this.foodname,
    required this.fooddescription,
    required this.foodamount,
    required this.fooddiscountamount,
    required this.foodid,
    required this.foodcode,
    required this.foodImage,
    required this.addOns,
  });

  CartItem copyWith({
    String? id,
    String? foodname,
    String? fooddescription,
    String? foodamount,
    String? fooddiscountamount,
    String? foodid,
    String? foodcode,
    String? foodImage,
    List<AddOnItemModel>? addOns,
  }) {
    return CartItem(
      id: id ?? this.id,
      foodname: foodname ?? this.foodname,
      fooddescription: fooddescription ?? this.fooddescription,
      foodamount: foodamount ?? this.foodamount,
      fooddiscountamount: fooddiscountamount ?? this.fooddiscountamount,
      foodid: foodid ?? this.foodid,
      foodcode: foodcode ?? this.foodcode,
      foodImage: foodImage ?? this.foodImage,
      addOns: addOns ?? this.addOns,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodname': foodname,
      'fooddescription': fooddescription,
      'foodamount': foodamount,
      'fooddiscountamount': fooddiscountamount,
      'foodid': foodid,
      'foodcode': foodcode,
      'foodImage': foodImage,
      'addOns': addOns.map((x) => x.toMap()).toList(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      foodname: map['foodname'],
      fooddescription: map['fooddescription'],
      foodamount: map['foodamount'],
      fooddiscountamount: map['fooddiscountamount'],
      foodid: map['foodid'],
      foodcode: map['foodcode'],
      foodImage: map['foodImage'],
      addOns: List<AddOnItemModel>.from(
          map['addOns']?.map((x) => AddOnItemModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartItem(id: $id, foodname: $foodname, fooddescription: $fooddescription, foodamount: $foodamount, fooddiscountamount: $fooddiscountamount, foodid: $foodid, foodcode: $foodcode, foodImage: $foodImage, addOns: $addOns)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.id == id &&
        other.foodname == foodname &&
        other.fooddescription == fooddescription &&
        other.foodamount == foodamount &&
        other.fooddiscountamount == fooddiscountamount &&
        other.foodid == foodid &&
        other.foodcode == foodcode &&
        other.foodImage == foodImage &&
        listEquals(other.addOns, addOns);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        foodname.hashCode ^
        fooddescription.hashCode ^
        foodamount.hashCode ^
        fooddiscountamount.hashCode ^
        foodid.hashCode ^
        foodcode.hashCode ^
        foodImage.hashCode ^
        addOns.hashCode;
  }
}
