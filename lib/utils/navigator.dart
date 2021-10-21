import 'package:cjspoton/model/coupon_discount_detail_model.dart';
import 'package:cjspoton/model/menu_screen_navigator_payload.dart';
import 'package:cjspoton/screen/add_delivery_addres/add_delivery_address_screen.dart';
import 'package:cjspoton/screen/add_delivery_addres/address_model.dart';
import 'package:cjspoton/screen/all_address/all_address.dart';
import 'package:cjspoton/screen/cart/cart_screen.dart';
import 'package:cjspoton/screen/cart/cart_variable_model.dart';
import 'package:cjspoton/screen/change_password/change_password.dart';
import 'package:cjspoton/screen/checkout/checkout_screen.dart';
import 'package:cjspoton/screen/choose_outlet/choose_outlet_screen.dart';
import 'package:cjspoton/screen/comming_soon/comming_soon_screen.dart';
import 'package:cjspoton/screen/coupon/coupon_screen.dart';
import 'package:cjspoton/screen/delivery_pincode/delivery_pincode_screen.dart';
import 'package:cjspoton/screen/e_dining/e_dining_datacontainer_model.dart';
import 'package:cjspoton/screen/e_dining/e_dining_table_booking_screen/e_dinig_table_booking_screen.dart';
import 'package:cjspoton/screen/e_dining/edining_cart/e_dining_cart_screen.dart';
import 'package:cjspoton/screen/e_dining/edining_menu/e_dining_menu_screen.dart';
import 'package:cjspoton/screen/feedback/feedback_screen.dart';
import 'package:cjspoton/screen/forgot_password/forgot_password_screen.dart';
import 'package:cjspoton/screen/introduction/introduction.dart';
import 'package:cjspoton/screen/ios_login_needed/ios_login_needed.dart';
import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/screen/login_email/login_email_screen.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/screen/main_container_ios_specific/main_container_ios_specific.dart';
import 'package:cjspoton/screen/menu/menu_screen.dart';
import 'package:cjspoton/screen/order/order_detail.dart';
import 'package:cjspoton/screen/order/order_details_screen.dart';
import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:cjspoton/screen/privacy_policy/privacy_policy_screen.dart';
import 'package:cjspoton/screen/register/register_screen.dart';
import 'package:cjspoton/screen/reset_password/reset_password_screen.dart';
import 'package:cjspoton/screen/search_page/search_page_screen.dart';
import 'package:cjspoton/screen/table_booking/table_booking_history/table_booking_history.dart';
import 'package:cjspoton/screen/table_booking/table_booking_screen/table_booking_screen.dart';
import 'package:cjspoton/screen/take_away/take_away_cart/take_away_cart_screen.dart';
import 'package:cjspoton/screen/take_away/take_away_menu/take_away_menu_screen.dart';
import 'package:cjspoton/screen/term_of_use/term_of_use_screen.dart';
import 'package:cjspoton/screen/update_address/update_delivery_address_screen.dart';
import 'package:cjspoton/update_profile/update_profile_screen.dart';
import 'package:cjspoton/widgets/webview_internal.dart';
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
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            previousScreen: settings.arguments.toString(),
          ),
        );
      case Introduction.INTRODUCTION_ROUTE:
        return MaterialPageRoute(builder: (_) => Introduction());
      case ChooseOutletScreen.CHOOSE_OUTLET_ROUTE:
        return MaterialPageRoute(builder: (_) => ChooseOutletScreen());
      case OrderDetailScreen.ORDER_DETAIL_ROUTE:
        return MaterialPageRoute(
            builder: (_) => OrderDetailScreen(
                orderDetailModel: settings.arguments as OrderDetailModel));
      case MainContainer.MAIN_CONTAINER_ROUTE:
        return MaterialPageRoute(
            builder: (_) => MainContainer(
                  initialIndex: settings.arguments as int,
                ));
      case MainContainerIosSpecific.MAIN_CONTAINER_IOS_SPECIFIC_ROUTE:
        return MaterialPageRoute(
            builder: (_) => MainContainerIosSpecific(
                  initialIndex: settings.arguments as int,
                ));
      case AddDeliveryAddress.ADD_DELIVERY_ADDRESS_ROUTE:
        return MaterialPageRoute(
            builder: (_) => AddDeliveryAddress(
                  filterPincode: settings.arguments as String,
                ));
      case AllAddressScreen.ALL_ADDRESS_ROUTE:
        return MaterialPageRoute(builder: (_) => AllAddressScreen());
      case UpdateDeliveryAddress.UPDATE_DELIVERY_ADDRESS_ROUTE:
        return MaterialPageRoute(
            builder: (_) => UpdateDeliveryAddress(
                  address: settings.arguments as AddressModel,
                ));
      case TermOfUseSceen.TERMS_ROUTE:
        return MaterialPageRoute(builder: (_) => TermOfUseSceen());
      case PrivacyPolicyScreen.PRIVACY_ROUTE:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
      case CartScreen.CART_ROUTE:
        return MaterialPageRoute(
            builder: (_) => CartScreen(
                  refreshMainContainerState: settings.arguments as Function(),
                ));
      case CheckoutScreen.CHECKOUT_ROUTE:
        return MaterialPageRoute(
            builder: (_) => CheckoutScreen(
                  cartVriablesModel: settings.arguments as CartVriablesModel,
                ));
      case MenuScreen.MENU_SCREEN_ROUTE:
        return MaterialPageRoute(
            builder: (_) => MenuScreen(
                  menuScreenNavigatorPayloadModel:
                      settings.arguments as MenuScreenNavigatorPayloadModel,
                ));
      case SearchPageScreen.SEARCH_SCREEN_ROUTE:
        return MaterialPageRoute(
            builder: (_) => SearchPageScreen(
                  menuScreenNavigatorPayloadModel:
                      settings.arguments as MenuScreenNavigatorPayloadModel,
                ));
      case CommingSoonScreen.COMMING_SOON_ROUTE:
        return MaterialPageRoute(
            builder: (_) => CommingSoonScreen(
                  menuScreenNavigatorPayloadModel:
                      settings.arguments as MenuScreenNavigatorPayloadModel,
                ));
      case ResetPasswordScreen.RESET_PASSWORD_ROUTE:
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case ChangePasswordScreen.CHANGE_PASSWORD_ROUTE:
        return MaterialPageRoute(builder: (_) => ChangePasswordScreen());
      case FeedbackScreen.FEEDBACK_ROUTE:
        return MaterialPageRoute(builder: (_) => FeedbackScreen());
      case UpdateProfileScreen.UPDATE_PROFILE_ROUTE:
        return MaterialPageRoute(builder: (_) => UpdateProfileScreen());
      case DeliverPincodeScreen.DELIVERY_PINCODE_ROUTE:
        return MaterialPageRoute(builder: (_) => DeliverPincodeScreen());
      case CouponScreen.COUPON_ROUTE:
        return MaterialPageRoute<CouponDiscountDetailModel>(
            builder: (_) => CouponScreen());
      case WebviewInternal.WEBVIEW_ROUTE:
        return MaterialPageRoute(
          builder: (_) => WebviewInternal(
            url: settings.arguments as String,
          ),
        );

      // Take Away
      case TakeAwayMenuScreen.TAKE_AWAY_MENU_SCREEN_ROUTE:
        return MaterialPageRoute(
          builder: (_) => TakeAwayMenuScreen(
            menuScreenNavigatorPayloadModel:
                settings.arguments as MenuScreenNavigatorPayloadModel,
          ),
        );
      case TakeAwayCartScreen.TAKE_AWAY_CART_ROUTE:
        return MaterialPageRoute(
            builder: (_) => TakeAwayCartScreen(
                  refreshMainContainerState: settings.arguments as Function(),
                ));

      // EDining
      case EdiningTableBookingScreen.TABLE_BOOKING_SCREEN_ROUTE:
        return MaterialPageRoute(
          builder: (_) => EdiningTableBookingScreen(
            menuScreenNavigatorPayloadModel:
                settings.arguments as MenuScreenNavigatorPayloadModel,
          ),
        );
      case EDiningMenuScreen.E_DINING_MENU_SCREEN_ROUTE:
        return MaterialPageRoute(
          builder: (_) => EDiningMenuScreen(
            dataContainer: settings.arguments as EDiningDataContainer,
          ),
        );
      case EDiningCartScreen.E_DINING_CART_ROUTE:
        return MaterialPageRoute(
          builder: (_) => EDiningCartScreen(
            dataContainer: settings.arguments as EDiningDataContainer,
          ),
        );

      // Table Booking
      case TableBookingScreen.TABLE_BOOKING_SCREEN_ROUTE:
        return MaterialPageRoute(
          builder: (_) => TableBookingScreen(
            menuScreenNavigatorPayloadModel:
                settings.arguments as MenuScreenNavigatorPayloadModel,
          ),
        );
      case TableBookingScreens.TABLE_BOOKING_HISTORY_ROUTE:
        return MaterialPageRoute(
          builder: (_) => TableBookingScreens(),
        );

      // iOS
      case IOSLoginNeeded.IOS_LOGIN_NEEDED_ROUTE:
        return MaterialPageRoute(
          builder: (_) => IOSLoginNeeded(),
        );

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
