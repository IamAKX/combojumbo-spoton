import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/coupon_discount_detail_model.dart';
import 'package:cjspoton/model/coupon_model.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/cart/cart_helper.dart';
import 'package:cjspoton/screen/cart/cart_variable_model.dart';
import 'package:cjspoton/screen/cart/grouped_cart_item_model.dart';
import 'package:cjspoton/screen/coupon/coupon_screen.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/update_profile/update_profile_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:crypto/crypto.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_payu_unofficial/flutter_payu_unofficial.dart';
import 'package:flutter_payu_unofficial/models/payment_params_model.dart';
import 'package:flutter_payu_unofficial/models/payment_result.dart';
import 'package:flutter_payu_unofficial/models/payment_status.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class TakeAwayCartScreen extends StatefulWidget {
  const TakeAwayCartScreen({Key? key, required this.refreshMainContainerState})
      : super(key: key);
  static const String TAKE_AWAY_CART_ROUTE = '/takeAwayCart';
  final Function() refreshMainContainerState;

  @override
  _TakeAwayCartScreenState createState() => _TakeAwayCartScreenState();
}

class _TakeAwayCartScreenState extends State<TakeAwayCartScreen> {
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

  @override
  Widget build(BuildContext context) {
    _cartServices = Provider.of<CartServices>(context);
    SnackBarService.instance.buildContext = context;
    user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    if (prefs.containsKey(PrefernceKey.COUPON_CODE) &&
        prefs.getString(PrefernceKey.COUPON_CODE)!.isNotEmpty) {
      couponDiscountDetailModel = CouponDiscountDetailModel.fromJson(
          prefs.getString(PrefernceKey.COUPON_CODE)!);
    }
    if (couponDiscountDetailModel != null &&
        couponDiscountDetailModel!.minimum_order_value.isNotEmpty &&
        CartHelper.getTotalPriceOfCart().toDouble() <
            couponDiscountDetailModel!.minimum_order_value.toDouble()) {
      couponDiscountDetailModel = null;
      selectedCoupon = null;
    }
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: (allChargesModel == null)
          ? Container()
          : InkWell(
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
                      } else if (CartHelper.getTotalPriceOfCart() <
                          allChargesModel!.min_order_online.toDouble()) {
                        SnackBarService.instance.showSnackBarError(
                            'Minimum value for online order should be ${Constants.RUPEE} ${allChargesModel!.min_order_online.toDouble().toStringAsFixed(2)}');
                        return;
                      } else {
                        // Start payment
                        CartVriablesModel cartVriablesModel = CartVriablesModel(
                          allChargesModel: allChargesModel,
                          selectedPincode: selectedPincode,
                          deliverySuggestion: sugestionCtrl.text,
                          couponDiscountDetailModel: couponDiscountDetailModel,
                          netAmount: CartHelper.getTakeAwayNetAmount(
                              allChargesModel,
                              selectedPincode,
                              couponDiscountDetailModel),
                        );
                        startPayUMoneyPayment(cartVriablesModel);
                      }
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
                              style:
                                  Theme.of(context).textTheme.caption?.copyWith(
                                        color: bgColor.withOpacity(0.7),
                                      ),
                            ),
                            Text(
                              '${Constants.RUPEE} ${CartHelper.getTakeAwayNetAmount(allChargesModel, selectedPincode, couponDiscountDetailModel).toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                    color: bgColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            )
                          ],
                        ),
                        Spacer(),
                        Text(
                          'PAY',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
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
      body: allChargesModel == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                SizedBox(
                  height: defaultPadding,
                ),
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
                    imageUrl: outletModel.image ?? '',
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  dense: true,
                  title: Text('${outletModel.outletName}'),
                  subtitle: Text('${outletModel.address}'),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(
                                      '${groupedItem.cartItem.foodname.toWordCase()}',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
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
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
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
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 2),
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
                        : ListTile(
                            leading: Image.asset(
                              'assets/images/discount.png',
                              width: 30,
                            ),
                            trailing: couponDiscountDetailModel != null
                                ? Icon(Icons.close)
                                : Icon(Icons.chevron_right_outlined),
                            subtitle: couponDiscountDetailModel != null
                                ? Text(
                                    'Offer applied on the bill',
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                : null,
                            title: couponDiscountDetailModel == null
                                ? Text('APPLY COUPON')
                                : Text(
                                    '${couponDiscountDetailModel!.coupon_code}'),
                            onTap: couponDiscountDetailModel != null
                                ? () {
                                    setState(() {
                                      couponDiscountDetailModel = null;
                                      prefs.remove(PrefernceKey.COUPON_CODE);
                                    });
                                  }
                                : () {
                                    Navigator.of(context)
                                        .pushNamed(CouponScreen.COUPON_ROUTE)
                                        .then((value) {
                                      setState(() {
                                        couponDiscountDetailModel =
                                            value as CouponDiscountDetailModel?;
                                        if (couponDiscountDetailModel != null)
                                          prefs.setString(
                                              PrefernceKey.COUPON_CODE,
                                              couponDiscountDetailModel!
                                                  .toJson());
                                      });
                                    });
                                  },
                          ),
                    // : DropdownSearch<String>(
                    //     mode: Mode.MENU,
                    //     showSelectedItem: true,
                    //     items: couponList.map((e) => e.code).toList(),
                    //     dropdownSearchDecoration: InputDecoration(
                    //       contentPadding: EdgeInsets.symmetric(
                    //           horizontal: defaultPadding),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(4),
                    //         borderSide: BorderSide(
                    //             color: hintColor.withOpacity(0.5)),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(4),
                    //         borderSide: BorderSide(
                    //             color: hintColor.withOpacity(0.5)),
                    //       ),
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(4),
                    //         borderSide: BorderSide(
                    //             color: hintColor.withOpacity(0.5)),
                    //       ),
                    //     ),
                    //     label: "Select coupons",
                    //     hint: "Select coupon to get discount",
                    //     onChanged: (value) {
                    //       setState(() {
                    //         selectedCoupon = value;
                    //         if (selectedCoupon == null) {
                    //           SnackBarService.instance.showSnackBarInfo(
                    //               'Select a coupon code to apply offer');
                    //         }
                    //         _cartServices
                    //             .verifyCoupon(
                    //                 selectedCoupon!,
                    //                 CartHelper.getTotalPriceOfCart()
                    //                     .toString(),
                    //                 context)
                    //             .then((value) {
                    //           couponDiscountDetailModel = value;
                    //         });
                    //       });
                    //     },
                    //     selectedItem: selectedCoupon),
                  ),
                  Container(
                    color: bgColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding / 2),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFBFDFF),
                        border: Border(
                          left: BorderSide(
                              color: hintColor.withOpacity(
                            0.5,
                          )),
                          top: BorderSide(color: hintColor.withOpacity(0.5)),
                          bottom: BorderSide(color: hintColor.withOpacity(0.5)),
                          right: BorderSide(color: hintColor.withOpacity(0.5)),
                        ),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(defaultPadding / 2),
                              child: Icon(
                                Icons.chat_bubble_outline,
                                color: hintColor,
                              ),
                            ),
                            VerticalDivider(
                              width: 1,
                              color: hintColor,
                            ),
                            Expanded(
                              child: TextField(
                                autocorrect: true,
                                controller: sugestionCtrl,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText:
                                      'Any Suggestions for the Chef? We will pass it on.',
                                  focusColor: primaryColor,
                                  alignLabelWithHint: false,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding,
                                      vertical: defaultPadding / 2),
                                  hoverColor: primaryColor,
                                  hintStyle: TextStyle(color: hintColor),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              Text('Taxes'),
                              Text(
                                  '${Constants.RUPEE} ${CartHelper.getServiceCharge(allChargesModel).toStringAsFixed(2)}')
                            ],
                          ),
                          if (allChargesModel!.Packing_Charge.toDouble() > 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Packing Charges'),
                                Text(
                                    '${Constants.RUPEE} ${double.parse(allChargesModel!.Packing_Charge).toStringAsFixed(2)}')
                              ],
                            ),
                          if (double.parse(allChargesModel!.Service_Charge) >
                              0) ...{
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Service Charge'),
                                Text(
                                    '${Constants.RUPEE} ${double.parse(allChargesModel!.Service_Charge).toStringAsFixed(2)}')
                              ],
                            ),
                          },
                          // if (CartHelper.getTotalPriceOfCart() >=
                          //     allChargesModel!.min_order_free_shipping
                          //         .toDouble())
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text('Delivery Fee'),
                          //       Text(
                          //           '${Constants.RUPEE} ${double.parse(selectedPincode.charge).toStringAsFixed(2)}')
                          //     ],
                          //   ),
                        },
                        if (couponDiscountDetailModel != null &&
                            CartHelper.getDiscountPrice(
                                    couponDiscountDetailModel) >
                                0)
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
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '${Constants.RUPEE} ${CartHelper.getTakeAwayNetAmount(allChargesModel, selectedPincode, couponDiscountDetailModel).toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
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

  Future<void> startPayUMoneyPayment(
      CartVriablesModel cartVriablesModel) async {
    if (user.email.isEmpty || user.name.isEmpty || user.phone.isEmpty) {
      SnackBarService.instance
          .showSnackBarError('Complete your profile to place order');
      Navigator.of(context)
          .pushNamed(UpdateProfileScreen.UPDATE_PROFILE_ROUTE)
          .then((value) {
        setState(() {
          user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
        });
      });
      return;
    }
    if (!Utilities().isValidEmail(user.email)) {
      SnackBarService.instance
          .showSnackBarError('Your email address is not valid.');
      Navigator.of(context)
          .pushNamed(UpdateProfileScreen.UPDATE_PROFILE_ROUTE)
          .then((value) {
        setState(() {});
      });
      return;
    }
    if (!Utilities().isValidPhone(user.phone)) {
      SnackBarService.instance
          .showSnackBarError('Your mobile number is not valid.');
      Navigator.of(context)
          .pushNamed(UpdateProfileScreen.UPDATE_PROFILE_ROUTE)
          .then((value) {
        setState(() {});
      });
      return;
    }
    PaymentParams _paymentParam = PaymentParams(
      merchantID: Constants.PAYU_MONEY_MERCHANT_ID,
      merchantKey: Constants.PAYU_MONEY_MERCHANT_KEY,
      salt: Constants.PAYU_MONEY_SALT,
      amount:
          "${CartHelper.getTakeAwayNetAmount(allChargesModel, selectedPincode, couponDiscountDetailModel).toStringAsFixed(2)}",
      // amount: '0.5',
      transactionID: "TXN${user.id}${DateTime.now().millisecond}",
      firstName: "${user.name}",
      email: "${user.email}",
      productName: "CJ SpotOn",
      phone: "${user.phone}",
      fURL: "https://www.payumoney.com/mobileapp/payumoney/failure.php",
      sURL: "https://www.payumoney.com/mobileapp/payumoney/success.php",
      udf1: "udf1",
      udf2: "udf2",
      udf3: "udf3",
      udf4: "udf4",
      udf5: "udf5",
      udf6: "",
      udf7: "",
      udf8: "",
      udf9: "",
      udf10: "",
      hash: "",
      isDebug: false,
    );

    var bytes = utf8.encode(
        "${_paymentParam.merchantKey}|${_paymentParam.transactionID}|${_paymentParam.amount}|${_paymentParam.productName}|${_paymentParam.firstName}|${_paymentParam.email}|udf1|udf2|udf3|udf4|udf5||||||${_paymentParam.salt}");
    String localHash = sha512.convert(bytes).toString();
    _paymentParam.hash = localHash;

    try {
      PayuPaymentResult _paymentResult =
          await FlutterPayuUnofficial.initiatePayment(
        paymentParams: _paymentParam,
        showCompletionScreen: true,
      );

      //Checks for success and prints result

      if (_paymentResult != null) {
        //_paymentResult.status is String of course. Directly fetched from payU's Payment response. More statuses can be compared manually

        if (_paymentResult.status == PayuPaymentStatus.success) {
          print("Success: ${_paymentResult.response}");
          showSuccessAlert(context, _paymentResult.response, _paymentParam,
              cartVriablesModel);
        } else if (_paymentResult.status == PayuPaymentStatus.failed) {
          print("Failed: ${_paymentResult.response}");
          showFailedAlert(context, _paymentResult.response!['Error_Message'],
              _paymentResult.response, _paymentParam, cartVriablesModel);
        } else if (_paymentResult.status == PayuPaymentStatus.cancelled) {
          print("Cancelled by User: ${_paymentResult.response}");
          showFailedAlert(context, 'Payment cancelled by user',
              _paymentResult.response, _paymentParam, cartVriablesModel);
        } else {
          print("Response: ${_paymentResult.response}");
          print("Status: ${_paymentResult.status}");
          showFailedAlert(context, 'Payment status : ${_paymentResult.status}',
              _paymentResult.response, _paymentParam, cartVriablesModel);
        }
      } else {
        print("Something's rotten here");
        showFailedAlert(context, 'Something went wrong!',
            _paymentResult.response, _paymentParam, cartVriablesModel);
      }
    } catch (e) {
      print(e);
    }
  }

  showSuccessAlert(BuildContext context, Map? response,
      PaymentParams paymentParam, CartVriablesModel cartVriablesModel) {
    String payUMoneyTxnId = response!['result']['payuMoneyId'];

    AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      borderSide: BorderSide(color: Colors.green, width: 2),
      width: 400,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Payment successful',
      desc: 'Your order has been received.',
      showCloseIcon: false,
      btnOkOnPress: () {
        SnackBarService.instance.showSnackBarInfo('Please wait...');

        _cartServices
            .placeTakeAwayOrder(cartVriablesModel, response, paymentParam,
                payUMoneyTxnId, 'success', context)
            .then((value) {
          if (value)
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainContainer.MAIN_CONTAINER_ROUTE, (route) => false,
                arguments: 1);
        });
      },
    )..show();
  }

  showFailedAlert(BuildContext context, String errorMsg, Map? response,
      PaymentParams paymentParam, CartVriablesModel cartVriablesModel) {
    String payUMoneyTxnId = paymentParam.transactionID;
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        borderSide: BorderSide(color: Colors.red, width: 2),
        width: 400,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
        headerAnimationLoop: false,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Payment Failed',
        desc: errorMsg,
        showCloseIcon: false,
        btnOkOnPress: () {
          SnackBarService.instance.showSnackBarInfo('Please wait...');

          _cartServices
              .placeTakeAwayOrder(cartVriablesModel, response, paymentParam,
                  payUMoneyTxnId, 'failure', context)
              .then((value) {});
        },
        btnOkColor: Colors.red)
      ..show();
  }
}
