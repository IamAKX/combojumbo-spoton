import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cjspoton/screen/add_delivery_addres/add_delivery_address_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);
  static const String CHECKOUT_ROUTE = '/checkout';

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int selectedAddress = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyedBgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Check out'),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: defaultPadding,
          ),
          Container(
            padding: EdgeInsets.all(defaultPadding),
            color: bgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DELIVERY ADDRESS',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: hintColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: Text('Home'),
                    subtitle: Text('Kalyani Nagar, Pune'),
                    trailing: Radio(
                      value: 1,
                      groupValue: selectedAddress,
                      onChanged: (value) {
                        setState(() {
                          selectedAddress = 1;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: hintColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.work_outline),
                    title: Text('Work'),
                    subtitle: Text('Bidhan Nagar, Pune'),
                    trailing: Radio(
                      value: 2,
                      groupValue: selectedAddress,
                      onChanged: (value) {
                        setState(() {
                          selectedAddress = 2;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed(AddDeliveryAddress.ADD_DELIVERY_ADDRESS_ROUTE),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.all(defaultPadding),
                    child: Text('ADD NEW ADDRESS'),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(4)),
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
                      '${Constants.RUPEE} 1002.80',
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
                  onTap: () => showSuccessAlert(context),
                  leading: Icon(Icons.credit_card_outlined),
                  title: Text('Pay via Credit/Debit Card'),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                ),
                Divider(
                  height: 1,
                  color: hintColor,
                  indent: 60,
                ),
                ListTile(
                  onTap: () => showFailedAlert(context),
                  leading: Icon(Icons.money),
                  title: Text('Pay via Cash'),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showSuccessAlert(BuildContext context) {
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
      btnOkOnPress: () {},
    )..show();
  }

  showFailedAlert(BuildContext context) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        borderSide: BorderSide(color: Colors.red, width: 2),
        width: 400,
        buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
        headerAnimationLoop: false,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Payment Failed',
        desc: 'Last transaction was unsuccessful.\nError code : 1234',
        showCloseIcon: false,
        btnOkOnPress: () {},
        btnOkColor: Colors.red)
      ..show();
  }
}
