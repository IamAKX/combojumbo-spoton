import 'dart:convert';

import 'package:cjspoton/model/add_on_model.dart';
import 'package:flutter/foundation.dart';

class FoodModel {
  String id;
  String foodname;
  String fooddescription;
  String foodamount;
  String fooddiscountamount;
  String foodid;
  String foodcode;
  String foodImage;
  List<AddOnModel> addons;
  FoodModel({
    required this.id,
    required this.foodname,
    required this.fooddescription,
    required this.foodamount,
    required this.fooddiscountamount,
    required this.foodid,
    required this.foodcode,
    required this.foodImage,
    required this.addons,
  });

  FoodModel copyWith({
    String? id,
    String? foodname,
    String? fooddescription,
    String? foodamount,
    String? fooddiscountamount,
    String? foodid,
    String? foodcode,
    String? foodImage,
    List<AddOnModel>? addons,
  }) {
    return FoodModel(
      id: id ?? this.id,
      foodname: foodname ?? this.foodname,
      fooddescription: fooddescription ?? this.fooddescription,
      foodamount: foodamount ?? this.foodamount,
      fooddiscountamount: fooddiscountamount ?? this.fooddiscountamount,
      foodid: foodid ?? this.foodid,
      foodcode: foodcode ?? this.foodcode,
      foodImage: foodImage ?? this.foodImage,
      addons: addons ?? this.addons,
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
      'addons': addons.map((x) => x.toMap()).toList(),
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: map['id'],
      foodname: map['foodname'],
      fooddescription: map['fooddescription'],
      foodamount: map['foodamount'],
      fooddiscountamount: map['fooddiscountamount'],
      foodid: map['foodid'],
      foodcode: map['foodcode'],
      foodImage: map['foodImage'],
      addons: List<AddOnModel>.from(
          map['addons']?.map((x) => AddOnModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) =>
      FoodModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FoodModel(id: $id, foodname: $foodname, fooddescription: $fooddescription, foodamount: $foodamount, fooddiscountamount: $fooddiscountamount, foodid: $foodid, foodcode: $foodcode, foodImage: $foodImage, addons: $addons)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodModel &&
        other.id == id &&
        other.foodname == foodname &&
        other.fooddescription == fooddescription &&
        other.foodamount == foodamount &&
        other.fooddiscountamount == fooddiscountamount &&
        other.foodid == foodid &&
        other.foodcode == foodcode &&
        other.foodImage == foodImage &&
        listEquals(other.addons, addons);
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
        addons.hashCode;
  }
}
