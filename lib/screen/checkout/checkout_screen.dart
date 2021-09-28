import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/add_delivery_addres/add_delivery_address_screen.dart';
import 'package:cjspoton/screen/add_delivery_addres/address_model.dart';
import 'package:cjspoton/screen/cart/cart_variable_model.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/services/address_service.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/update_profile/update_profile_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_payu_unofficial/flutter_payu_unofficial.dart';
import 'package:flutter_payu_unofficial/models/payment_params_model.dart';
import 'package:flutter_payu_unofficial/models/payment_result.dart';
import 'package:flutter_payu_unofficial/models/payment_status.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key, required this.cartVriablesModel})
      : super(key: key);
  static const String CHECKOUT_ROUTE = '/checkout';
  final CartVriablesModel cartVriablesModel;
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
  String selectedAddress = '';
  late CartServices _cartServices;
  late AddressService _addressService;
  List<AddressModel> addressList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => reloadAddressList(context));
  }

  reloadAddressList(BuildContext context) {
    _addressService.getAllAddress(context).then(
      (value) {
        setState(() {
          addressList = value;
          addressList = addressList
              .where((element) =>
                  element.pincode ==
                  widget.cartVriablesModel.selectedPincode.pincode)
              .toList();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _cartServices = Provider.of<CartServices>(context);
    _addressService = Provider.of<AddressService>(context);
    SnackBarService.instance.buildContext = context;

    return Scaffold(
      backgroundColor: greyedBgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Checkout'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: defaultPadding * 2,
                ),
                Container(
                  padding: EdgeInsets.all(defaultPadding),
                  color: bgColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DELIVERY ADDRESS',
                            style:
                                Theme.of(context).textTheme.subtitle1?.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed(
                                    AddDeliveryAddress
                                        .ADD_DELIVERY_ADDRESS_ROUTE,
                                    arguments: widget.cartVriablesModel
                                        .selectedPincode.pincode)
                                .then((value) {
                              reloadAddressList(context);
                            }),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 0.5,
                                vertical: defaultPadding * 0.25,
                              ),
                              child: Text(
                                'ADD ADDRESS',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(color: textColor),
                              ),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Visibility(
                        visible: addressList.isEmpty,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: defaultPadding * 2,
                              ),
                              SvgPicture.asset(
                                'assets/svg/add_address.svg',
                                width: 200,
                              ),
                              SizedBox(
                                height: defaultPadding,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(defaultPadding),
                                child: Text(
                                  'Please add your address',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      for (AddressModel address in addressList) ...{
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: hintColor),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: RadioListTile(
                            // leading: getAddressIcon(address.addressType),
                            secondary: getAddressIcon(address.addressType),
                            title: Text('${address.addressType}'),
                            isThreeLine: true,
                            subtitle: Text(
                                '${address.address1}\n${address.address2}'),
                            value: address.id,
                            groupValue: selectedAddress,
                            onChanged: (value) {
                              setState(() {
                                selectedAddress = value.toString();
                              });
                            },
                          ),
                          // child: RadioListTile(
                          //    value: address.id,
                          //     groupValue: selectedAddress,
                          //     onChanged: (value) {
                          //       setState(() {
                          //         selectedAddress = value.toString();
                          //       });
                          //     },
                          // ),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                      },
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: defaultPadding * 2,
          ),
          Container(
            padding: EdgeInsets.all(defaultPadding),
            color: bgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PAYMENT',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${Constants.RUPEE} ${widget.cartVriablesModel.netAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                ListTile(
                  onTap: () {
                    if (selectedAddress.isEmpty) {
                      SnackBarService.instance
                          .showSnackBarError('Select delivery address');
                      return;
                    }
                    startPayUMoneyPayment();
                  },
                  leading: Icon(Icons.credit_card_outlined),
                  title: Text('Pay via Credit/Debit Card'),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                ),
                // Divider(
                //   height: 1,
                //   color: hintColor,
                //   indent: 60,
                // ),
                // ListTile(
                //   onTap: () => null,
                //   leading: Icon(Icons.money),
                //   title: Text('Pay via Cash'),
                //   trailing: Icon(Icons.keyboard_arrow_right_outlined),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
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
        AddressModel address =
            addressList.firstWhere((element) => element.id == selectedAddress);
        _cartServices
            .placeOrder(cartVriablesModel, address, response, paymentParam,
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
          AddressModel address = addressList
              .firstWhere((element) => element.id == selectedAddress);
          _cartServices
              .placeOrder(cartVriablesModel, address, response, paymentParam,
                  payUMoneyTxnId, 'failure', context)
              .then((value) {});
        },
        btnOkColor: Colors.red)
      ..show();
  }

  Future<void> startPayUMoneyPayment() async {
    if (user.email.isEmpty || user.name.isEmpty || user.phone.isEmpty) {
      SnackBarService.instance
          .showSnackBarError('Complete your profile to place order');
      Navigator.of(context)
          .pushNamed(UpdateProfileScreen.UPDATE_PROFILE_ROUTE)
          .then((value) {
        setState(() {});
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
      amount: "${widget.cartVriablesModel.netAmount}",
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
              widget.cartVriablesModel);
        } else if (_paymentResult.status == PayuPaymentStatus.failed) {
          print("Failed: ${_paymentResult.response}");
          showFailedAlert(context, _paymentResult.response!['Error_Message'],
              _paymentResult.response, _paymentParam, widget.cartVriablesModel);
        } else if (_paymentResult.status == PayuPaymentStatus.cancelled) {
          print("Cancelled by User: ${_paymentResult.response}");
          showFailedAlert(context, 'Payment cancelled by user',
              _paymentResult.response, _paymentParam, widget.cartVriablesModel);
        } else {
          print("Response: ${_paymentResult.response}");
          print("Status: ${_paymentResult.status}");
          showFailedAlert(context, 'Payment status : ${_paymentResult.status}',
              _paymentResult.response, _paymentParam, widget.cartVriablesModel);
        }
      } else {
        print("Something's rotten here");
        showFailedAlert(context, 'Something went wrong!',
            _paymentResult.response, _paymentParam, widget.cartVriablesModel);
      }
    } catch (e) {
      print(e);
    }
  }

  getAddressIcon(String addressType) {
    switch (addressType) {
      case 'HOME':
        return Icon(Icons.home_outlined);
      case 'WORK':
        return Icon(Icons.work_outline);
      case 'OTHER':
        return Icon(Icons.pin_drop_outlined);
      default:
        return Icon(Icons.pin_drop_outlined);
    }
  }
}
