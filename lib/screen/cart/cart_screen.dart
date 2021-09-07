import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/cart_item.dart';
import 'package:cjspoton/model/coupon_discount_detail_model.dart';
import 'package:cjspoton/model/coupon_model.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/cart/cart_variable_model.dart';
import 'package:cjspoton/screen/cart/grouped_cart_item_model.dart';
import 'package:cjspoton/screen/checkout/checkout_screen.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/update_profile/update_profile_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
  late UserModel user;
  late CartServices _cartServices;
  PincodeModel selectedPincode = Constants.getDefaultPincode();
  List<CouponModel> couponList = [];
  AllChargesModel? allChargesModel = null;
  String? selectedCoupon;
  CouponDiscountDetailModel? couponDiscountDetailModel = null;

  refreshState() {
    widget.refreshMainContainerState();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _cartServices.fetchAllPincodes(context).then(
        (value) {
          setState(() {
            _cartServices
                .getAllCoupon(context)
                .then((value) => couponList = value);
            _cartServices
                .getAllCharges(context)
                .then((value) => allChargesModel = value);
          });
        },
      ),
    );
  }

  Widget _customDropDownForPincode(
      BuildContext context, PincodeModel? item, String itemDesignation) {
    if (item == null) {
      return Container();
    }

    return Container(
      child: (item.pincode == null)
          ? ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              title: Text("No item selected"),
            )
          : ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              title: Text(item.pincode),
              subtitle: Text(
                item.location.toString(),
              ),
            ),
    );
  }

  Widget _customPopupItemBuilderForPincode(
      BuildContext context, PincodeModel item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        selected: isSelected,
        title: Text(item.pincode),
        subtitle: Text(item.location.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _cartServices = Provider.of<CartServices>(context);
    SnackBarService.instance.buildContext = context;
    user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: CartHelper.getCartCount() == 0
            ? null
            : () {
                if (user.email.isEmpty ||
                    user.name.isEmpty ||
                    user.phone.isEmpty) {
                  SnackBarService.instance.showSnackBarError(
                      'Complete your profile to place order');
                  Navigator.of(context)
                      .pushNamed(UpdateProfileScreen.UPDATE_PROFILE_ROUTE)
                      .then((value) {
                    setState(() {});
                  });
                } else
                  Navigator.of(context).pushNamed(
                    CheckoutScreen.CHECKOUT_ROUTE,
                    arguments: CartVriablesModel(
                      allChargesModel: allChargesModel,
                      selectedPincode: selectedPincode,
                      deliverySuggestion: sugestionCtrl.text,
                      couponDiscountDetailModel: couponDiscountDetailModel,
                      netAmount: CartHelper.getNetAmount(allChargesModel,
                          selectedPincode, couponDiscountDetailModel),
                    ),
                  );
              },
        child: Visibility(
          visible: CartHelper.getCartCount() > 0,
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
                        '${CartHelper.getCartCount()} ITEM${CartHelper.getCartCount() > 1 ? 'S' : ''}',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              color: bgColor.withOpacity(0.7),
                            ),
                      ),
                      Text(
                        '${Constants.RUPEE} ${CartHelper.getNetAmount(allChargesModel, selectedPincode, couponDiscountDetailModel).toStringAsFixed(2)}',
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
          CartHelper.getCartCount() == 0
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: defaultPadding * 2,
                      ),
                      SvgPicture.asset(
                        'assets/svg/empty_cart.svg',
                        width: 300,
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          'Your cart is empty',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    for (GroupedCartItemModel groupedItem
                        in CartHelper.getGroupedCartItem()) ...{
                      Container(
                        color: bgColor,
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: defaultPadding / 2),
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
                                '${groupedItem.cartItem.foodname.toWordCase()}',
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
          if (CartHelper.getCartCount() > 0) ...{
            Container(
              color: bgColor,
              padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              // child: Row(
              //   children: [
              //     Expanded(
              //       child: TextField(
              //         autocorrect: true,
              //         controller: promoCodeCtrl,
              //         decoration: InputDecoration(
              //           hintText: 'Enter promo code',
              //           focusColor: primaryColor,
              //           alignLabelWithHint: false,
              //           filled: true,
              //           fillColor: Colors.white,
              //           contentPadding:
              //               EdgeInsets.symmetric(horizontal: defaultPadding),
              //           hoverColor: primaryColor,
              //           hintStyle: TextStyle(color: hintColor),
              //           enabledBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(4),
              //               bottomLeft: Radius.circular(4),
              //             ),
              //             borderSide:
              //                 BorderSide(color: hintColor.withOpacity(0.5)),
              //           ),
              //           focusedBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(4),
              //               bottomLeft: Radius.circular(4),
              //             ),
              //             borderSide:
              //                 BorderSide(color: hintColor.withOpacity(0.5)),
              //           ),
              //           border: OutlineInputBorder(
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(4),
              //               bottomLeft: Radius.circular(4),
              //             ),
              //             borderSide:
              //                 BorderSide(color: hintColor.withOpacity(0.5)),
              //           ),
              //         ),
              //       ),
              //     ),
              //     InkWell(
              //       onTap: () {},
              //       child: Container(
              //         alignment: Alignment.center,
              //         padding: EdgeInsets.symmetric(
              //           horizontal: 5,
              //           vertical: 14,
              //         ),
              //         decoration: BoxDecoration(
              //           color: primaryColor,
              //           borderRadius: BorderRadius.only(
              //             topRight: Radius.circular(4),
              //             bottomRight: Radius.circular(4),
              //           ),
              //         ),
              //         width: 80,
              //         child: Text(
              //           'APPLY',
              //           style: Theme.of(context)
              //               .textTheme
              //               .button
              //               ?.copyWith(color: bgColor),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              child: couponList.isEmpty
                  ? Container()
                  : DropdownSearch<String>(
                      mode: Mode.MENU,
                      showSelectedItem: true,
                      items: couponList.map((e) => e.code).toList(),
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: defaultPadding),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide:
                              BorderSide(color: hintColor.withOpacity(0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide:
                              BorderSide(color: hintColor.withOpacity(0.5)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide:
                              BorderSide(color: hintColor.withOpacity(0.5)),
                        ),
                      ),
                      label: "Select coupons",
                      hint: "Select coupon to get discount",
                      onChanged: (value) {
                        setState(() {
                          selectedCoupon = value;
                          if (selectedCoupon == null) {
                            SnackBarService.instance.showSnackBarInfo(
                                'Select a coupon code to apply offer');
                          }
                          _cartServices
                              .verifyCoupon(
                                  selectedCoupon!,
                                  CartHelper.getTotalPriceOfCart().toString(),
                                  context)
                              .then((value) {
                            couponDiscountDetailModel = value;
                          });
                        });
                      },
                      selectedItem: selectedCoupon),
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
                          '${Constants.RUPEE} ${CartHelper.getTotalPriceOfCart().toStringAsFixed(2)}')
                    ],
                  ),
                  if (allChargesModel != null) ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Service Tax'),
                        Text(
                            '${Constants.RUPEE} ${double.parse(allChargesModel!.Service_Charge).toStringAsFixed(2)}')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Packing charge'),
                        Text(
                            '${Constants.RUPEE} ${double.parse(allChargesModel!.Packing_Charge).toStringAsFixed(2)}')
                      ],
                    ),
                  },
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Fees'),
                      Text(
                          '${Constants.RUPEE} ${double.parse(selectedPincode.charge).toStringAsFixed(2)}')
                    ],
                  ),
                  if (couponDiscountDetailModel != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Discount',
                          style: TextStyle(color: Colors.green),
                        ),
                        Text(
                          '${Constants.RUPEE} ${CartHelper.getDiscountPrice(couponDiscountDetailModel).toStringAsFixed(2)}',
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
                        '${Constants.RUPEE} ${CartHelper.getNetAmount(allChargesModel, selectedPincode, couponDiscountDetailModel).toStringAsFixed(2)}',
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
            ),
          },
        ],
      ),
    );
  }
}
