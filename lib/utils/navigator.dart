import 'package:cjspoton/screen/add_delivery_addres/add_delivery_address_screen.dart';
import 'package:cjspoton/screen/choose_outlet/choose_outlet_screen.dart';
import 'package:cjspoton/screen/forgot_password/forgot_password_screen.dart';
import 'package:cjspoton/screen/introduction/introduction.dart';
import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/screen/login_email/login_email_screen.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:cjspoton/screen/privacy_policy/privacy_policy_screen.dart';
import 'package:cjspoton/screen/register/register_screen.dart';
import 'package:cjspoton/screen/term_of_use/term_of_use_screen.dart';
import 'package:flutter/material.dart';

class NavRoute {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case LoginEmailScreen.EMAIL_LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => LoginEmailScreen());
      case RegisterScreen.REGISTER_ROUTE:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case ForgotPasswordScreen.FORGOT_PASSWORD_ROUTE:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case OtpVerificationScreen.OTP_VERIFICATION_ROUTE:
        return MaterialPageRoute(builder: (_) => OtpVerificationScreen());
      case Introduction.INTRODUCTION_ROUTE:
        return MaterialPageRoute(builder: (_) => Introduction());
      case ChooseOutletScreen.CHOOSE_OUTLET_ROUTE:
        return MaterialPageRoute(builder: (_) => ChooseOutletScreen());
      case MainContainer.MAIN_CONTAINER_ROUTE:
        return MaterialPageRoute(builder: (_) => MainContainer());
      case AddDeliveryAddress.ADD_DELIVERY_ADDRESS_ROUTE:
        return MaterialPageRoute(builder: (_) => AddDeliveryAddress());
      case TermOfUseSceen.TERMS_ROUTE:
        return MaterialPageRoute(builder: (_) => TermOfUseSceen());
      case PrivacyPolicyScreen.PRIVACY_ROUTE:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());

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
