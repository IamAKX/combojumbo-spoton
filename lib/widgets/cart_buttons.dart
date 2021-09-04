import 'package:cjspoton/model/cart_item.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/home/home_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class CartButton {
  Container getCartButtonComplex(
      BuildContext context, FoodModel foodModel, Function() refreshState) {
    CartItem cartItem = CartHelper.transformFoodModel(foodModel);
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        border: Border.all(color: primaryColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              CartHelper.removeItemToCart(cartItem);
              refreshState();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Icon(
                Icons.remove,
                color: primaryColor,
                size: 15,
              ),
            ),
          ),
          Text('${CartHelper.getItemCountInCart(cartItem)}'),
          InkWell(
            onTap: () {
              CartHelper.addItemToCart(cartItem);
              refreshState();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Icon(
                Icons.add,
                color: primaryColor,
                size: 15,
              ),
            ),
          )
        ],
      ),
    );
  }

  InkWell getCartButtonSimple(
      BuildContext context, FoodModel foodModel, Function() refreshState) {
    return InkWell(
      onTap: () {
        CartItem cartItem = CartHelper.transformFoodModel(foodModel);
        CartHelper.addItemToCart(cartItem);
        refreshState();
      },
      child: Container(
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'ADD',
          style: Theme.of(context).textTheme.button?.copyWith(
                color: primaryColor,
              ),
        ),
      ),
    );
  }
}
