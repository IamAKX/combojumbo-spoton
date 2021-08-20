import 'package:cjspoton/screen/introduction/introduction.dart';
import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:flutter/material.dart';

class NavRoute {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case OtpVerificationScreen.OTP_VERIFICATION_ROUTE:
        return MaterialPageRoute(builder: (_) => OtpVerificationScreen());
      case Introduction.INTRODUCTION_ROUTE:
        return MaterialPageRoute(builder: (_) => Introduction());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('Undefined route'),
        ),
      );
    });
  }
}
