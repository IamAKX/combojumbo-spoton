import 'dart:async';

import 'package:cjspoton/screen/introduction/introduction.dart';
import 'package:cjspoton/services/auth_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key, required this.previousScreen})
      : super(key: key);
  static const String OTP_VERIFICATION_ROUTE = '/otpVerification';
  final String previousScreen;
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController _otpCtrl = TextEditingController();
  late Size screenSize;
  late AuthenticationService _auth;

  late Timer _timer;
  int _start = 60;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _start = 10;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthenticationService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          'Back to Login',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        centerTitle: false,
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.help_outline_outlined,
          //   ),
          // )
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
          style: Theme.of(context).textTheme.headline4?.copyWith(
              color: textColor, fontWeight: FontWeight.bold, height: 0.98),
        ),
        SizedBox(
          height: 5,
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
            if (_auth.status != AuthStatus.Authenticating)
              _auth.verifyOTP(_otpCtrl.text, widget.previousScreen, context);
          },
          child: Text(
            _auth.status != AuthStatus.Authenticating
                ? 'VERIFY NOW'
                : 'Please wait...',
            style: Theme.of(context)
                .textTheme
                .button
                ?.copyWith(color: Colors.white),
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        InkWell(
          onTap: () {
            if (_start == 0) {
              _auth.resendOTP(widget.previousScreen, context);
              startTimer();
            }
          },
          child: Align(
            alignment: Alignment.center,
            child: Text(
              _start > 0 ? 'Resend OTP in $_start seconds' : 'RESEND OTP',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: _start > 0 ? hintColor : primaryColor,
                  ),
            ),
          ),
        )
      ],
    );
  }
}
