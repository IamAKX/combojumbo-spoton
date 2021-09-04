import 'dart:convert';

import 'package:cjspoton/model/cart_item.dart';

class GroupedCartItemModel {
  CartItem cartItem;
  int quantity;
  GroupedCartItemModel({
    required this.cartItem,
    required this.quantity,
  });

  GroupedCartItemModel copyWith({
    CartItem? cartItem,
    int? quantity,
  }) {
    return GroupedCartItemModel(
      cartItem: cartItem ?? this.cartItem,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartItem': cartItem.toMap(),
      'quantity': quantity,
    };
  }

  factory GroupedCartItemModel.fromMap(Map<String, dynamic> map) {
    return GroupedCartItemModel(
      cartItem: CartItem.fromMap(map['cartItem']),
      quantity: map['quantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupedCartItemModel.fromJson(String source) =>
      GroupedCartItemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'GroupedCartItemModel(cartItem: $cartItem, quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupedCartItemModel &&
        other.cartItem == cartItem &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => cartItem.hashCode ^ quantity.hashCode;
}
