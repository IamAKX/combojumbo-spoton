import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cjspoton/model/food_model.dart';

class CategoryModel {
  String categoryName;
  String foodcount;
  String id;
  String startsfrom;
  String image;
  List<FoodModel> foodList;
  CategoryModel({
    required this.categoryName,
    required this.foodcount,
    required this.id,
    required this.startsfrom,
    required this.image,
    required this.foodList,
  });

  CategoryModel copyWith({
    String? categoryName,
    String? foodcount,
    String? id,
    String? startsfrom,
    String? image,
    List<FoodModel>? foodList,
  }) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      foodcount: foodcount ?? this.foodcount,
      id: id ?? this.id,
      startsfrom: startsfrom ?? this.startsfrom,
      image: image ?? this.image,
      foodList: foodList ?? this.foodList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'foodcount': foodcount,
      'id': id,
      'startsfrom': startsfrom,
      'image': image,
      'foodList': foodList.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryName: map['categoryName'],
      foodcount: map['foodcount'],
      id: map['id'],
      startsfrom: map['startsfrom'],
      image: map['image'],
      foodList: List<FoodModel>.from(
          map['foodList']?.map((x) => FoodModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(categoryName: $categoryName, foodcount: $foodcount, id: $id, startsfrom: $startsfrom, image: $image, foodList: $foodList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.categoryName == categoryName &&
        other.foodcount == foodcount &&
        other.id == id &&
        other.startsfrom == startsfrom &&
        other.image == image &&
        listEquals(other.foodList, foodList);
  }

  @override
  int get hashCode {
    return categoryName.hashCode ^
        foodcount.hashCode ^
        id.hashCode ^
        startsfrom.hashCode ^
        image.hashCode ^
        foodList.hashCode;
  }
}
