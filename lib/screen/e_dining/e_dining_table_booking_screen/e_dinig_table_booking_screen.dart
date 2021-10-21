import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/all_charges_model.dart';
import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/section_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/e_dining/e_dining_datacontainer_model.dart';
import 'package:cjspoton/screen/e_dining/edining_menu/e_dining_menu_screen.dart';
import 'package:cjspoton/screen/table_booking/table_booking_model/table_booking_model.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class EdiningTableBookingScreen extends StatefulWidget {
  const EdiningTableBookingScreen({
    Key? key,
    required this.menuScreenNavigatorPayloadModel,
  }) : super(key: key);
  static const String TABLE_BOOKING_SCREEN_ROUTE = '/ediningtableBookingScreen';
  // final Function() refreshMainContainerState;
  final MenuScreenNavigatorPayloadModel menuScreenNavigatorPayloadModel;

  @override
  _EdiningTableBookingScreenState createState() =>
      _EdiningTableBookingScreenState();
}

class _EdiningTableBookingScreenState extends State<EdiningTableBookingScreen> {
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
  DateTime? selectedDate;

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
        title: Text('E Dining'),
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
                InkWell(
                  onTap: () async {
                    // DatePicker.showDateTimePicker(
                    //   context,
                    //   showTitleActions: true,
                    //   theme: DatePickerTheme(
                    //     doneStyle: TextStyle(color: primaryColor),
                    //     backgroundColor: bgColor,
                    //     itemStyle: TextStyle(color: textColor),
                    //   ),
                    //   minTime: DateTime.now(),
                    //   maxTime: DateTime.now().add(
                    //     Duration(
                    //       days: 30,
                    //     ),
                    //   ),
                    //   onConfirm: (date) {
                    //     if (date.isBefore(DateTime.now())) {
                    //       SnackBarService.instance
                    //           .showSnackBarError('Enter a valid date');
                    //       slotCtrl.text = '';
                    //     } else
                    //       slotCtrl.text =
                    //           DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
                    //   },
                    //   currentTime: DateTime.now(),
                    // );

                    selectedDate = await showRoundedDatePicker(
                      context: context,
                      theme: ThemeData(
                        primarySwatch: primaryColor,
                      ),
                      firstDate: DateTime.now().subtract(Duration(days: 1)),
                      lastDate: DateTime.now().add(
                        Duration(
                          days: 30,
                        ),
                      ),
                      initialDate: selectedDate,
                    );
                    TimeOfDay? selectedTime;
                    if (selectedDate != null) {
                      selectedTime = await showRoundedTimePicker(
                        context: context,
                        theme: ThemeData(
                          primarySwatch: primaryColor,
                        ),
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        selectedDate = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime.hour,
                            selectedTime.minute);

                        if (selectedDate!.isBefore(DateTime.now())) {
                          SnackBarService.instance
                              .showSnackBarError('Enter a valid date');
                          slotCtrl.text = '';
                        } else
                          slotCtrl.text = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(selectedDate!);
                      } else {
                        SnackBarService.instance
                            .showSnackBarInfo('Select time');
                      }
                    } else {
                      SnackBarService.instance
                          .showSnackBarInfo('Select a date');
                    }
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
                    EDiningDataContainer dataContainer = EDiningDataContainer(
                        menuScreenNavigatorPayloadModel:
                            widget.menuScreenNavigatorPayloadModel,
                        tableBookingModel: tableBookingModel);
                    Navigator.of(context).pushNamed(
                        EDiningMenuScreen.E_DINING_MENU_SCREEN_ROUTE,
                        arguments: dataContainer);
                  },
                  child: Text(
                    // 'Pay ${Constants.RUPEE}${allChargesModel!.Table_Booking_Charge}',
                    'Reserve table',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  'This total sum of ${Constants.RUPEE}${allChargesModel!.EDining_Charges}/- will be adjusted in your final bill.',
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
}
