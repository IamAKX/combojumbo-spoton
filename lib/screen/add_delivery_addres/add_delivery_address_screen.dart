import 'package:cjspoton/model/city_model.dart';
import 'package:cjspoton/model/pincode_model.dart';
import 'package:cjspoton/model/state_model.dart';
import 'package:cjspoton/screen/add_delivery_addres/address_model.dart';
import 'package:cjspoton/services/address_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddDeliveryAddress extends StatefulWidget {
  const AddDeliveryAddress({Key? key, required this.filterPincode})
      : super(key: key);
  static const String ADD_DELIVERY_ADDRESS_ROUTE = '/addDeliveryAddress';
  final String filterPincode;

  @override
  _AddDeliveryAddressState createState() => _AddDeliveryAddressState();
}

class _AddDeliveryAddressState extends State<AddDeliveryAddress> {
  // TextEditingController deliveryCtrl = TextEditingController();
  TextEditingController completeAddressCtrl1 = TextEditingController();
  TextEditingController completeAddressCtrl2 = TextEditingController();
  TextEditingController landmarkCtrl = TextEditingController();
  TextEditingController deliveryInstructionCtrl = TextEditingController();
  List<StateModel> stateList = [];
  List<CityModel> cityList = [];
  List<PincodeModel> pincodeList = [];
  StateModel? selectedState = null;
  CityModel? selectedCity =
      CityModel(id: '2726', name: 'Navi Mumbai', state_id: '22');
  PincodeModel? selectedPincode = null;
  String addressType = 'HOME';
  late Size screenSize;
  late PincodeModel pincodeModel;
  late AddressService _addressService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _addressService.fetchAllPincodes(context).then((value) {
        pincodeList = value;
        if (widget.filterPincode != '') {
          pincodeList = pincodeList
              .where((e) => e.outletid == widget.filterPincode)
              .toList();
        }
        if (widget.filterPincode != '')
          selectedPincode = pincodeList.firstWhere(
              (element) => element.outletid == widget.filterPincode);
        else {
          PincodeModel pincodeModel = Constants.getDefaultPincode();
          selectedPincode = pincodeList
              .firstWhere((element) => element.pincode == pincodeModel.pincode);
        }

        _addressService.getStateList(context).then(
          (value) {
            setState(() async {
              stateList = value;
              selectedState =
                  stateList.firstWhere((element) => element.id == '22');

              await _addressService
                  .getCityList(selectedState!, context)
                  .then((value) {
                cityList = value;
                if (selectedState != null && selectedState!.id == '22')
                  selectedCity =
                      cityList.firstWhere((element) => element.id == '2726');
                else
                  selectedCity = cityList.first;
              });
            });
          },
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _addressService = Provider.of<AddressService>(context);
    SnackBarService.instance.buildContext = context;
    pincodeModel = Constants.getDefaultPincode();
    // deliveryCtrl.text = pincodeModel.pincode;
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: false,
        title: Text('Add Delivery Address'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(bottom: defaultPadding),
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.of(context)
                    //         .pushNamed(
                    //             DeliverPincodeScreen.DELIVERY_PINCODE_ROUTE)
                    //         .then((value) {
                    //       setState(() {});
                    //     });
                    //   },
                    //   child: CustomTextFieldWithHeadingActionButton(
                    //     teCtrl: deliveryCtrl,
                    //     hint: 'Delivery Area',
                    //     enabled: false,
                    //     inputType: TextInputType.streetAddress,
                    //     icondata: Icons.location_pin,
                    //     onTap: () {},
                    //   ),
                    // ),
                    CustomTextFieldWithHeading(
                      teCtrl: completeAddressCtrl1,
                      hint: 'Address 1',
                      inputType: TextInputType.streetAddress,
                    ),
                    CustomTextFieldWithHeading(
                      teCtrl: completeAddressCtrl2,
                      hint: 'Address 2',
                      inputType: TextInputType.streetAddress,
                    ),
                    CustomTextFieldWithHeading(
                      teCtrl: landmarkCtrl,
                      hint: 'Landmark',
                      inputType: TextInputType.streetAddress,
                    ),
                    Text(
                      'State',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    DropdownSearch<StateModel>(
                      mode: Mode.DIALOG,
                      searchBoxDecoration: InputDecoration(
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
                      popupTitle: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          'Select state',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      selectedItem: selectedState,
                      showSearchBox: true,
                      showSelectedItem: true,
                      items: stateList,
                      compareFn: (item, selectedItem) =>
                          item.id == selectedItem?.id,
                      itemAsString: (item) => item.name,
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
                      label: "Select state",
                      hint: "Select State",
                      onChanged: (value) {
                        setState(() {
                          selectedState = value;
                          if (selectedState == null) {
                            SnackBarService.instance
                                .showSnackBarInfo('Select your state');
                            return;
                          }

                          _addressService
                              .getCityList(selectedState!, context)
                              .then((value) {
                            cityList = value;
                            if (selectedState != null &&
                                selectedState!.id == '22')
                              selectedCity = cityList.firstWhere(
                                  (element) => element.id == '2726');
                            else
                              selectedCity = cityList.first;
                          });
                        });
                      },
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Text(
                      'City',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    DropdownSearch<CityModel>(
                      mode: Mode.DIALOG,
                      searchBoxDecoration: InputDecoration(
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
                      popupTitle: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          'Select city',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      selectedItem: selectedCity,
                      showSearchBox: true,
                      showSelectedItem: true,
                      items: cityList,
                      itemAsString: (item) => item.name,
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
                      label: "Select city",
                      hint: "Select City",
                      compareFn: (item, selectedItem) =>
                          item.id == selectedItem?.id,
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                          if (selectedCity == null) {
                            SnackBarService.instance
                                .showSnackBarInfo('Select your city');
                            return;
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),

                    Text(
                      'Pincode',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    DropdownSearch<PincodeModel>(
                      mode: Mode.DIALOG,
                      searchBoxDecoration: InputDecoration(
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
                      popupTitle: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Text(
                          'Select pincode',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      selectedItem: selectedPincode,
                      showSearchBox: true,
                      showSelectedItem: true,
                      items: pincodeList,
                      itemAsString: (item) => '${item.pincode}',
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
                      label: "Select pincode",
                      hint: "Select pincode",
                      compareFn: (item, selectedItem) =>
                          item.id == selectedItem?.id,
                      onChanged: (value) {
                        setState(() {
                          selectedPincode = value;
                          if (selectedCity == null) {
                            SnackBarService.instance
                                .showSnackBarInfo('Select your pincode');
                            return;
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),

                    Visibility(
                      visible: false,
                      child: CustomTextFieldWithHeading(
                        teCtrl: deliveryInstructionCtrl,
                        hint: 'Delivery Instruction',
                        inputType: TextInputType.text,
                      ),
                    ),
                    Text(
                      'Nickname',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: defaultPadding / 2,
                    ),
                    ToggleSwitch(
                      minHeight: 50,
                      minWidth: (screenSize.width) / 3,
                      inactiveBgColor: bgColor,
                      activeFgColor: bgColor,
                      activeBgColor: [
                        Colors.blueGrey,
                        Colors.blueGrey,
                        Colors.blueGrey,
                      ],
                      borderColor: [
                        hintColor.withOpacity(0.5),
                      ],
                      borderWidth: 1,
                      dividerColor: hintColor.withOpacity(0.5),
                      initialLabelIndex: 0,
                      totalSwitches: 3,
                      labels: ['HOME', 'WORK', 'OTHER'],
                      onToggle: (index) {
                        // setState(() {
                        addressType =
                            ['HOME', 'WORK', 'OTHER'].elementAt(index);
                        // });
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CLOSE',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            color: hintColor.withOpacity(0.5),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(vertical: defaultPadding),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: defaultPadding / 2,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (selectedPincode == null ||
                            completeAddressCtrl1.text.isEmpty ||
                            selectedCity == null ||
                            selectedState == null) {
                          SnackBarService.instance
                              .showSnackBarError('Address 1 is mandatory');
                          return;
                        } else {
                          AddressModel addressModel = AddressModel(
                              pincode: selectedPincode!.id,
                              address1: completeAddressCtrl1.text,
                              address2: completeAddressCtrl2.text,
                              landmark: landmarkCtrl.text,
                              city: selectedCity!,
                              stateModel: selectedState!,
                              id: DateTime.now().millisecond.toString(),
                              deliveryInstruction: deliveryInstructionCtrl.text,
                              addressType: addressType);

                          _addressService.addAddress(addressModel, context);
                          // Utilities.addAddress(addressModel);
                          // SnackBarService.instance
                          //     .showSnackBarSuccess('Address saved');
                          // Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: bgColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
