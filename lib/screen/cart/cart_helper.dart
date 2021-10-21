import 'dart:developer';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/add_on_model_item.dart';
import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/cart_item.dart';
import 'package:cjspoton/model/coupon_discount_detail_model.dart';
import 'package:cjspoton/model/food_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/screen/cart/grouped_cart_item_model.dart';
import 'package:cjspoton/screen/checkout/grouped_cart_model.dart';
import 'package:cjspoton/utils/prefs_key.dart';

import '../../utils/constants.dart';

class CartHelper {
  static int getCartCount() {
    if (prefs.getStringList(PrefernceKey.LOCAL_CART) == null) return 0;

    return prefs.getStringList(PrefernceKey.LOCAL_CART)!.length;
  }

  static addItemToCart(CartItem cartItem) {
    List<String> cart = [];
    if (prefs.getStringList(PrefernceKey.LOCAL_CART) != null)
      cart = prefs.getStringList(PrefernceKey.LOCAL_CART)!;
    cart.add(cartItem.toJson());
    prefs.setStringList(PrefernceKey.LOCAL_CART, cart);
  }

  static removeItemToCart(CartItem cartItem) {
    if (prefs.getStringList(PrefernceKey.LOCAL_CART) == null) return;
    List<CartItem> cart = getAllItemsFromCart();
    if (cartItem.addOns.isEmpty) {
      for (CartItem item in cart) {
        if (item.id == cartItem.id) {
          cart.remove(item);
          break;
        }
      }
    } else {
      for (CartItem item in cart) {
        if (item.id == cartItem.id &&
            item.addOns.length == cartItem.addOns.length) {
          bool isSame = true;
          for (AddOnItemModel i in item.addOns) {
            if (!cartItem.addOns.any((element) => element.id == i.id)) {
              isSame = false;
              break;
            }
          }
          if (isSame) {
            cart.remove(item);
            break;
          }
        }
      }
    }
    setAllItemsToCart(cart);
  }

  static clearCart() {
    prefs.setStringList(PrefernceKey.LOCAL_CART, []);
  }

  static List<CartItem> getAllItemsFromCart() {
    List<CartItem> cart = [];
    if (prefs.getStringList(PrefernceKey.LOCAL_CART) == null) return cart;

    for (String c in prefs.getStringList(PrefernceKey.LOCAL_CART)!)
      cart.add(CartItem.fromJson(c));
    return cart;
  }

  static setAllItemsToCart(List<CartItem> cart) {
    List<String> cartString = [];
    for (CartItem c in cart) cartString.add(c.toJson());
    prefs.setStringList(PrefernceKey.LOCAL_CART, cartString);
  }

  static getItemCountInCart(CartItem item) {
    List<CartItem> cart = getAllItemsFromCart();
    int count = 0;
    for (CartItem c in cart) {
      if (c.id == item.id) count++;
    }
    return count;
  }

  static CartItem transformFoodModel(FoodModel food) {
    CartItem cartItem = CartItem(
        id: food.id,
        foodname: food.foodname,
        fooddescription: food.fooddescription,
        foodamount: food.foodamount,
        fooddiscountamount: food.fooddiscountamount,
        foodid: food.foodid,
        foodcode: food.foodcode,
        foodImage: food.foodImage,
        addOns: []);
    return cartItem;
  }

  static List<GroupedCartItemModel> getGroupedCartItem() {
    List<CartItem> cart = getAllItemsFromCart();
    List<GroupedCartItemModel> groupedCart = [];
    for (CartItem item in cart) {
      if (groupedCart.any((element) => element.cartItem.id == item.id))
        groupedCart
            .firstWhere((element) => element.cartItem.id == item.id)
            .quantity++;
      else
        groupedCart.add(GroupedCartItemModel(cartItem: item, quantity: 1));
    }
    return groupedCart;
  }

  static double getTotalPriceOfCart() {
    double amt = 0.0;
    List<CartItem> cart = getAllItemsFromCart();
    for (CartItem item in cart) amt += double.parse(item.foodamount);
    return amt;
  }

  static double getDiscountPrice(
      CouponDiscountDetailModel? couponDiscountDetailModel) {
    if (couponDiscountDetailModel == null) return 0;
    double amt = getTotalPriceOfCart();

    switch (couponDiscountDetailModel.coupon_type) {
      case 'Percentage':
        amt = amt * double.parse(couponDiscountDetailModel.coupon_value) / 100;
        if (amt >= couponDiscountDetailModel.maximum_order_value.toDouble() &&
            couponDiscountDetailModel.maximum_order_value.toDouble() != 0) {
          return couponDiscountDetailModel.maximum_order_value.toDouble();
        } else {
          return amt;
        }
      default:
        return double.parse(couponDiscountDetailModel.coupon_value);
    }
  }

  static double getNetAmount(
      AllChargesModel? allChargesModel,
      PincodeModel selectedPincode,
      CouponDiscountDetailModel? couponDiscountDetailModel) {
    double amt = getTotalPriceOfCart();
    if (allChargesModel != null)
      amt += double.parse(allChargesModel.Packing_Charge) +
          double.parse(allChargesModel.Service_Charge) +
          getServiceCharge(allChargesModel);
    if (getTotalPriceOfCart() >=
        allChargesModel!.min_order_free_shipping.toDouble())
      amt += selectedPincode.charge.toDouble();
    if (couponDiscountDetailModel != null)
      amt -= getDiscountPrice(couponDiscountDetailModel);
    return amt;
  }

  static double getTakeAwayNetAmount(
      AllChargesModel? allChargesModel,
      PincodeModel selectedPincode,
      CouponDiscountDetailModel? couponDiscountDetailModel) {
    double amt = getTotalPriceOfCart();
    if (allChargesModel != null)
      amt += double.parse(allChargesModel.Packing_Charge) +
          double.parse(allChargesModel.Service_Charge) +
          getServiceCharge(allChargesModel);

    if (couponDiscountDetailModel != null)
      amt -= getDiscountPrice(couponDiscountDetailModel);
    return amt;
  }

  static double getEDiningNetAmount(
      AllChargesModel? allChargesModel,
      PincodeModel selectedPincode,
      CouponDiscountDetailModel? couponDiscountDetailModel) {
    double amt = getTotalPriceOfCart();
    if (allChargesModel != null)
      amt += double.parse(allChargesModel.Packing_Charge) +
          double.parse(allChargesModel.Service_Charge) +
          double.parse(allChargesModel.EDining_Charges) +
          getServiceCharge(allChargesModel);

    if (couponDiscountDetailModel != null)
      amt -= getDiscountPrice(couponDiscountDetailModel);
    return amt;
  }

  static double getServiceCharge(
    AllChargesModel? allChargesModel,
  ) {
    double amt = getTotalPriceOfCart();
    double gst = double.parse(allChargesModel!.gst);
    return amt * gst / 100;
  }

  static List<Map<String, dynamic>> getGroupedCartJson() {
    List<Map<String, dynamic>> list = [];
    for (GroupedCartItemModel m in getGroupedCartItem()) {
      GroupedCartModel model = GroupedCartModel(
          id: m.cartItem.id,
          foodname: m.cartItem.foodname,
          fooddescription: m.cartItem.fooddescription,
          foodamount: m.cartItem.foodamount,
          fooddiscountamount: m.cartItem.fooddiscountamount,
          foodid: m.cartItem.foodid,
          foodcode: m.cartItem.foodcode,
          foodImage: m.cartItem.foodImage,
          addOns: [],
          qty: m.quantity);
      list.add(model.toMap());
    }
    return list;
  }
}
