import 'package:cjspoton/screen/introduction/introduction.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);
  static const String OTP_VERIFICATION_ROUTE = '/otpVerification';

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController _otpCtrl = TextEditingController();
  late Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          'Back to Login',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.help_outline_outlined,
            ),
          )
        ],
      ),
      body: body(),
    );
  }

  body() {
    screenSize = MediaQuery.of(context).size;
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding * 2,
        vertical: defaultPadding,
      ),
      children: [
        Text(
          'Verify your\nphone number',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(color: textColor, fontWeight: FontWeight.bold),
        ),
        Text(
          'Enter your OTP code',
          style:
              Theme.of(context).textTheme.subtitle1?.copyWith(color: hintColor),
        ),
        SizedBox(
          height: defaultPadding * 3,
        ),
        PinCodeTextField(
          length: 4,
          obscureText: false,
          animationType: AnimationType.fade,
          textStyle: Theme.of(context).textTheme.headline4?.copyWith(
                color: textColor,
              ),
          pinTheme: PinTheme(
            borderWidth: 1,
            activeColor: hintColor,
            inactiveColor: hintColor,
            selectedColor: primaryColor,
            selectedFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            errorBorderColor: hintColor,
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 80,
            fieldWidth: (screenSize.width - (defaultPadding * 4) - 60) / 4,
            activeFillColor: Colors.white,
          ),
          animationDuration: Duration(milliseconds: 300),
          enableActiveFill: true,
          controller: _otpCtrl,
          onCompleted: (v) {
            print("Completed");
          },
          onChanged: (String value) {
            _otpCtrl.text = value;
          },
          appContext: context,
        ),
        SizedBox(
          height: defaultPadding * 3,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Introduction.INTRODUCTION_ROUTE);
          },
          child: Text(
            'VERIFY NOW',
            style: Theme.of(context)
                .textTheme
                .button
                ?.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
