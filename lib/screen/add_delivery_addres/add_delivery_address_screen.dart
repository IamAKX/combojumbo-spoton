import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:cjspoton/widgets/custom_heading_textfield_with_actionbutton.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddDeliveryAddress extends StatefulWidget {
  const AddDeliveryAddress({Key? key}) : super(key: key);
  static const String ADD_DELIVERY_ADDRESS_ROUTE = '/addDeliveryAddress';

  @override
  _AddDeliveryAddressState createState() => _AddDeliveryAddressState();
}

class _AddDeliveryAddressState extends State<AddDeliveryAddress> {
  TextEditingController deliveryCtrl = TextEditingController();
  TextEditingController completeAddressCtrl = TextEditingController();
  TextEditingController deliveryInstructionCtrl = TextEditingController();
  late Size screenSize;
  @override
  Widget build(BuildContext context) {
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
                    CustomTextFieldWithHeadingActionButton(
                      teCtrl: deliveryCtrl,
                      hint: 'Delivery Area',
                      inputType: TextInputType.streetAddress,
                      icondata: Icons.location_pin,
                      onTap: () {},
                    ),
                    CustomTextFieldWithHeading(
                      teCtrl: completeAddressCtrl,
                      hint: 'Complete Address',
                      inputType: TextInputType.streetAddress,
                    ),
                    CustomTextFieldWithHeading(
                      teCtrl: deliveryInstructionCtrl,
                      hint: 'Delivery Instruction',
                      inputType: TextInputType.text,
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
                      initialLabelIndex: 2,
                      totalSwitches: 3,
                      labels: ['HOME', 'WORK', 'OTHER'],
                      onToggle: (index) {},
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
                      onPressed: () {},
                      child: Text(
                        'SAVE CHANGES',
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
