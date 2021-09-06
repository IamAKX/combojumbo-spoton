import 'dart:convert';

import 'package:cjspoton/screen/order/order_food_model.dart';

class OrderMenuDetails {
  OrderFoodModel food;
  String addons;
  OrderMenuDetails({
    required this.food,
    required this.addons,
  });

  OrderMenuDetails copyWith({
    OrderFoodModel? food,
    String? addons,
  }) {
    return OrderMenuDetails(
      food: food ?? this.food,
      addons: addons ?? this.addons,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'food': food.toMap(),
      'addons': addons,
    };
  }

  factory OrderMenuDetails.fromMap(Map<String, dynamic> map) {
    return OrderMenuDetails(
      food: OrderFoodModel.fromMap(map['food']),
      addons: map['addons'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderMenuDetails.fromJson(String source) =>
      OrderMenuDetails.fromMap(json.decode(source));

  @override
  String toString() => 'OrderMenuDetails(food: $food, addons: $addons)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderMenuDetails &&
        other.food == food &&
        other.addons == addons;
  }

  @override
  int get hashCode => food.hashCode ^ addons.hashCode;
}
