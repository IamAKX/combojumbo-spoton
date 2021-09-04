import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/cart_item.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/cart/grouped_cart_model.dart';
import 'package:cjspoton/screen/checkout/checkout_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen(
      {Key? key, required Function() this.refreshMainContainerState})
      : super(key: key);
  static const String CART_ROUTE = '/cart';
  final Function() refreshMainContainerState;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  TextEditingController promoCodeCtrl = TextEditingController();
  TextEditingController sugestionCtrl = TextEditingController();
  OutletModel outletModel =
      OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);

  refreshState() {
    widget.refreshMainContainerState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(CheckoutScreen.CHECKOUT_ROUTE),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.green,
          elevation: 10,
          margin: EdgeInsets.all(defaultPadding),
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: bgColor,
                  size: 37,
                ),
                SizedBox(
                  width: defaultPadding / 2,
                ),
                Container(
                  color: bgColor.withOpacity(0.7),
                  width: 1,
                  height: 40,
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${CartHelper.getCartCount()} ITEMS',
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            color: bgColor.withOpacity(0.7),
                          ),
                    ),
                    Text(
                      '${Constants.RUPEE} ${6 * 6 * 25 - 20 + 62.8 + 10}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: bgColor,
                            fontWeight: FontWeight.bold,
                          ),
                    )
                  ],
                ),
                Spacer(),
                Text(
                  'PAY',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: bgColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  width: defaultPadding,
                ),
                Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: bgColor,
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Cart'),
        centerTitle: false,
      ),
      backgroundColor: greyedBgColor,
      body: ListView(
        children: [
          ListTile(
            tileColor: bgColor,
            minVerticalPadding: 1.0,
            contentPadding: EdgeInsets.only(
              left: 10,
              bottom: 1,
              top: 1,
              right: 10,
            ),
            leading: CachedNetworkImage(
              imageUrl:
                  "https://images.unsplash.com/photo-1514933651103-005eec06c04b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1567&q=80",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            dense: true,
            title: Text('${outletModel.outletName}'),
            subtitle: Text('${outletModel.outletId}'),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Column(
            children: [
              for (GroupedCartItemModel groupedItem
                  in CartHelper.getGroupedCartItem()) ...{
                Container(
                  color: bgColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.adjust_outlined,
                        color: Colors.green,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          '${groupedItem.cartItem.foodname.toCamelCase()}',
                          style: Theme.of(context).textTheme.subtitle1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                CartHelper.removeItemToCart(
                                    groupedItem.cartItem);
                                refreshState();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: defaultPadding,
                                    vertical: defaultPadding / 2),
                                child: Icon(
                                  Icons.remove,
                                  color: primaryColor,
                                  size: 15,
                                ),
                              ),
                            ),
                            Text('${groupedItem.quantity}'),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  CartHelper.addItemToCart(
                                      groupedItem.cartItem);
                                  refreshState();
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: defaultPadding,
                                    vertical: defaultPadding / 2),
                                child: Icon(
                                  Icons.add,
                                  color: primaryColor,
                                  size: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Text(
                        '${Constants.RUPEE} ${groupedItem.quantity * int.parse(groupedItem.cartItem.foodamount)}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  color: hintColor,
                )
              },
            ],
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Container(
            color: bgColor,
            padding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autocorrect: true,
                    controller: promoCodeCtrl,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      focusColor: primaryColor,
                      alignLabelWithHint: false,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: defaultPadding),
                      hoverColor: primaryColor,
                      hintStyle: TextStyle(color: hintColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                        borderSide:
                            BorderSide(color: hintColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                        borderSide:
                            BorderSide(color: hintColor.withOpacity(0.5)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                        borderSide:
                            BorderSide(color: hintColor.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    width: 80,
                    child: Text(
                      'APPLY',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          ?.copyWith(color: bgColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: bgColor,
            padding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Row(
              children: [
                Container(
                  height: 88,
                  width: 60,
                  padding: EdgeInsets.all(defaultPadding / 2),
                  decoration: BoxDecoration(
                    color: Color(0xFFFBFDFF),
                    border: Border(
                      left: BorderSide(
                          color: hintColor.withOpacity(
                        0.5,
                      )),
                      top: BorderSide(color: hintColor.withOpacity(0.5)),
                      bottom: BorderSide(color: hintColor.withOpacity(0.5)),
                    ),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: hintColor,
                  ),
                ),
                Expanded(
                  child: TextField(
                    autocorrect: true,
                    controller: sugestionCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Any suggestions? Will pass it on',
                      focusColor: primaryColor,
                      alignLabelWithHint: false,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: defaultPadding,
                          vertical: defaultPadding / 2),
                      hoverColor: primaryColor,
                      hintStyle: TextStyle(color: hintColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        borderSide:
                            BorderSide(color: hintColor.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        borderSide:
                            BorderSide(color: hintColor.withOpacity(0.5)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        borderSide:
                            BorderSide(color: hintColor.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Container(
            padding: EdgeInsets.all(defaultPadding),
            color: bgColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Item Total'),
                    Text(
                        '${CartHelper.getTotalPriceOfCart().toStringAsFixed(2)}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Restaurant Charges'),
                    Text('${Constants.RUPEE} 62.80')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Fees'),
                    Text('${Constants.RUPEE} 10.00')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Discount',
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                      '${Constants.RUPEE} 20',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Divider(
                  color: borderColor,
                  height: 1,
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TO PAY',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${Constants.RUPEE} ${6 * 6 * 25 - 20 + 62.8 + 10}',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: defaultPadding * 8,
          )
        ],
      ),
    );
  }
}
