import 'dart:convert';

import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_order_food_model.dart';

class TableBookingMenuDetails {
  String addons;
  TableBookingOrderFoodModel food;
  TableBookingMenuDetails({
    required this.addons,
    required this.food,
  });

  TableBookingMenuDetails copyWith({
    String? addons,
    TableBookingOrderFoodModel? food,
  }) {
    return TableBookingMenuDetails(
      addons: addons ?? this.addons,
      food: food ?? this.food,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addons': addons,
      'food': food.toMap(),
    };
  }

  factory TableBookingMenuDetails.fromMap(Map<String, dynamic> map) {
    return TableBookingMenuDetails(
      addons: map['addons'],
      food: TableBookingOrderFoodModel.fromMap(map['food']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TableBookingMenuDetails.fromJson(String source) =>
      TableBookingMenuDetails.fromMap(json.decode(source));

  @override
  String toString() => 'TableBookingMenuDetails(addons: $addons, food: $food)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableBookingMenuDetails &&
        other.addons == addons &&
        other.food == food;
  }

  @override
  int get hashCode => addons.hashCode ^ food.hashCode;
}
