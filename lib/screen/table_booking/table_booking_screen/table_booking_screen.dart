import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/section_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/cart/cart_variable_model.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/screen/table_booking/table_booking_history/table_booking_history.dart';
import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_model.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/update_profile/update_profile_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_payu_unofficial/flutter_payu_unofficial.dart';
import 'package:flutter_payu_unofficial/models/payment_params_model.dart';
import 'package:flutter_payu_unofficial/models/payment_result.dart';
import 'package:flutter_payu_unofficial/models/payment_status.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';

class TableBookingScreen extends StatefulWidget {
  const TableBookingScreen({
    Key? key,
    required this.menuScreenNavigatorPayloadModel,
  }) : super(key: key);
  static const String TABLE_BOOKING_SCREEN_ROUTE = '/tableBookingScreen';
  // final Function() refreshMainContainerState;
  final MenuScreenNavigatorPayloadModel menuScreenNavigatorPayloadModel;

  @override
  _TableBookingScreenState createState() => _TableBookingScreenState();
}

class _TableBookingScreenState extends State<TableBookingScreen> {
  UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);

  List<SectionModel> sectionList = [];
  late CartServices _cartServices;

  late OutletModel selectedOutlet;
  SectionModel? selectedSection = null;
  AllChargesModel? allChargesModel = null;

  TextEditingController outletCtrl = TextEditingController();
  TextEditingController slotCtrl = TextEditingController();
  TextEditingController guestCtrl = TextEditingController();
  TextEditingController sectionCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _cartServices.fetchAllPincodes(context).then(
        (value) {
          setState(() {
            _cartServices
                .getAllCharges(context)
                .then((value) => allChargesModel = value);
            _cartServices.getAllSection(context).then((value) {
              sectionList = value;
              selectedSection = sectionList.first;
            });
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _cartServices = Provider.of<CartServices>(context);
    SnackBarService.instance.buildContext = context;
    sectionCtrl.text =
        selectedSection == null || selectedSection!.sectionname == null
            ? ''
            : selectedSection!.sectionname;
    selectedOutlet =
        OutletModel.fromJson(prefs.getString(PrefernceKey.SELECTED_OUTLET)!);
    outletCtrl.text = selectedOutlet.outletName;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Book Table'),
      ),
      body: (allChargesModel == null || sectionList.isEmpty)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(defaultPadding),
              children: [
                Text(
                  'Opt for a section and book your table. An booking charge of Rs 99 will be levied which will be adjusted on your final bill.',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        color: textColor,
                      ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Select Section',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          // fontWeight: FontWeight.bold,
                          color: textColor,
                          fontSize: 18,
                        ),
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: sectionList.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedSection = sectionList.elementAt(index);
                        });
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      selectedSection == null ||
                                              selectedSection!.id !=
                                                  sectionList
                                                      .elementAt(index)
                                                      .id
                                          ? hintColor
                                          : Colors.transparent,
                                      BlendMode.saturation,
                                    ),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      child: CachedNetworkImage(
                                        imageUrl: sectionList
                                            .elementAt(index)
                                            .image
                                            .trim(),
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Text(
                                  '${sectionList.elementAt(index).sectionname}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(
                                        // fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: selectedSection!.id ==
                                  sectionList.elementAt(index).id,
                              child: Positioned(
                                right: 4,
                                child: Container(
                                  width: 30,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      color: primaryColor,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.green,
                                    child: Icon(
                                      Icons.check,
                                      color: bgColor,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                CustomTextFieldWithHeading(
                  teCtrl: outletCtrl,
                  hint: 'Outlet',
                  inputType: TextInputType.text,
                  enabled: false,
                  fillColor: hintColor.withOpacity(0.5),
                ),
                CustomTextFieldWithHeading(
                  teCtrl: sectionCtrl,
                  hint: 'Section',
                  inputType: TextInputType.text,
                  enabled: false,
                  fillColor: hintColor.withOpacity(0.5),
                ),
                // Text(
                //   'Section',
                //   style: Theme.of(context)
                //       .textTheme
                //       .subtitle2
                //       ?.copyWith(fontWeight: FontWeight.bold),
                // ),
                // SizedBox(
                //   height: 8,
                // ),
                // DropdownSearch<SectionModel>(
                //   mode: Mode.DIALOG,
                //   searchBoxDecoration: InputDecoration(
                //     contentPadding:
                //         EdgeInsets.symmetric(horizontal: defaultPadding),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(4),
                //       borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(4),
                //       borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(4),
                //       borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                //     ),
                //   ),
                //   popupTitle: Padding(
                //     padding: const EdgeInsets.all(defaultPadding),
                //     child: Text(
                //       'Select Section',
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     ),
                //   ),
                //   showSearchBox: true,
                //   showSelectedItem: true,
                //   items: sectionList,
                //   itemAsString: (item) => item.sectionname,
                //   dropdownSearchDecoration: InputDecoration(
                //     contentPadding:
                //         EdgeInsets.symmetric(horizontal: defaultPadding),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(4),
                //       borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(4),
                //       borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(4),
                //       borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                //     ),
                //   ),
                //   label: "Select Section",
                //   hint: "Select Section",
                //   compareFn: (item, selectedItem) =>
                //       item.id == selectedItem?.id,
                //   onChanged: (value) {
                //     setState(() {
                //       if (value == null) {
                //         SnackBarService.instance
                //             .showSnackBarInfo('Select an Section');
                //         return;
                //       } else
                //         selectedSection = value;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: defaultPadding,
                // ),
                InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      theme: DatePickerTheme(
                        doneStyle: TextStyle(color: primaryColor),
                        backgroundColor: bgColor,
                        itemStyle: TextStyle(color: textColor),
                      ),
                      minTime: DateTime.now(),
                      maxTime: DateTime.now().add(
                        Duration(
                          days: 30,
                        ),
                      ),
                      onConfirm: (date) {
                        if (date.isBefore(DateTime.now())) {
                          SnackBarService.instance
                              .showSnackBarError('Enter a valid date');
                          slotCtrl.text = '';
                        } else
                          slotCtrl.text =
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                      },
                      currentTime: DateTime.now(),
                    );
                  },
                  child: CustomTextFieldWithHeading(
                    teCtrl: slotCtrl,
                    hint: 'Booking Slot',
                    inputType: TextInputType.text,
                    enabled: false,
                  ),
                ),
                CustomTextFieldWithHeading(
                  teCtrl: guestCtrl,
                  hint: 'No of Guests',
                  inputType: TextInputType.number,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                TextButton(
                  onPressed: () {
                    if (selectedSection == null) {
                      SnackBarService.instance
                          .showSnackBarError('Select a section');
                      return;
                    }
                    if (slotCtrl.text.isEmpty) {
                      SnackBarService.instance
                          .showSnackBarError('Select booking slot');
                      return;
                    }
                    if (guestCtrl.text.isEmpty ||
                        guestCtrl.text.toDouble() <= 0 ||
                        guestCtrl.text.toDouble() >
                            selectedSection!.guest.toDouble()) {
                      SnackBarService.instance.showSnackBarError(
                          'Max number of guest for the section is ${selectedSection!.guest}');
                      return;
                    }
                    TableBookingModel tableBookingModel = TableBookingModel(
                        section: selectedSection!,
                        outlet: selectedOutlet,
                        numberOfGuest: guestCtrl.text,
                        bookingSlot: slotCtrl.text,
                        allChargesModel: allChargesModel);

                    startPayUMoneyPayment(tableBookingModel);
                  },
                  child: Text(
                    'Pay ${Constants.RUPEE}${allChargesModel!.Table_Booking_Charge.toDouble()}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  'This total sum of ${Constants.RUPEE}${allChargesModel!.Table_Booking_Charge.toDouble()}/- will be adjusted in your final bill.',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }

  Future<void> startPayUMoneyPayment(
      TableBookingModel tableBookingModel) async {
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
      amount:
          "${tableBookingModel.allChargesModel!.Table_Booking_Charge.toDouble().toStringAsFixed(2)}",
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
              tableBookingModel);
        } else if (_paymentResult.status == PayuPaymentStatus.failed) {
          print("Failed: ${_paymentResult.response}");
          showFailedAlert(context, _paymentResult.response!['Error_Message'],
              _paymentResult.response, _paymentParam, tableBookingModel);
        } else if (_paymentResult.status == PayuPaymentStatus.cancelled) {
          print("Cancelled by User: ${_paymentResult.response}");
          showFailedAlert(context, 'Payment cancelled by user',
              _paymentResult.response, _paymentParam, tableBookingModel);
        } else {
          print("Response: ${_paymentResult.response}");
          print("Status: ${_paymentResult.status}");
          showFailedAlert(context, 'Payment status : ${_paymentResult.status}',
              _paymentResult.response, _paymentParam, tableBookingModel);
        }
      } else {
        print("Something's rotten here");
        showFailedAlert(context, 'Something went wrong!',
            _paymentResult.response, _paymentParam, tableBookingModel);
      }
    } catch (e) {
      print(e);
    }
  }

  showSuccessAlert(BuildContext context, Map? response,
      PaymentParams paymentParam, TableBookingModel tableBookingModel) {
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
      desc: 'Your booking is confirmed.',
      showCloseIcon: false,
      btnOkOnPress: () {
        SnackBarService.instance.showSnackBarInfo('Please wait...');

        _cartServices
            .placeTableBookingOrder(tableBookingModel, response, paymentParam,
                payUMoneyTxnId, 'success', context)
            .then((value) {
          if (value)
            Navigator.of(context)
                .pushNamed(TableBookingScreens.TABLE_BOOKING_HISTORY_ROUTE)
                .then((value) => Navigator.of(context).pushNamedAndRemoveUntil(
                    MainContainer.MAIN_CONTAINER_ROUTE, (route) => false,
                    arguments: 0));
        });
      },
    )..show();
  }

  showFailedAlert(BuildContext context, String errorMsg, Map? response,
      PaymentParams paymentParam, TableBookingModel tableBookingModel) {
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
              .placeTableBookingOrder(tableBookingModel, response, paymentParam,
                  payUMoneyTxnId, 'failure', context)
              .then((value) {});
        },
        btnOkColor: Colors.red)
      ..show();
  }
}
