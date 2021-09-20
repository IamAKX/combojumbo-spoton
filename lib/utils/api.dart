class API {
  static const String BASE_URL = 'https://www.combojumbo.in/api/';

  static const String PhoneRegisteration = '${BASE_URL}register.php';
  static const String GoogleRegisteration = '${BASE_URL}googlelogin.php';
  static const String FacebookRegisteration = '${BASE_URL}facebooklogin.php';

  static const String PhoneLogin = '${BASE_URL}login.php';
  static const String VerifyOTP = '${BASE_URL}otpverify.php';
  static const String ResendOTP = '${BASE_URL}resend-otp.php';

  static const String ForgotPasswordVerifyOTP =
      '${BASE_URL}forgototpverify.php';
  static const String ForgotPasswordResendOTP = '${BASE_URL}resendotp.php';
  static const String ForgotPassword = '${BASE_URL}forgotpassword.php';
  static const String ResetPassword = '${BASE_URL}reset-password.php';
  static const String ChangePassword = '${BASE_URL}resetpassword.php';

  static const String Profile = '${BASE_URL}myprofile.php';
  static const String UpdateProfile = '${BASE_URL}update-profile';

  static const String Outlets = '${BASE_URL}outlet.php';
  static const String Categories = '${BASE_URL}category';
  static const String FoodItems = '${BASE_URL}food.php';
  static const String PincodeCharge = '${BASE_URL}pincode.php';
  static const String AllCharges = '${BASE_URL}charges';
  static const String CouponCode = '${BASE_URL}couponlist';
  static const String VerifyCouponCode = '${BASE_URL}coupon';
  static const String PlaceOrder = '${BASE_URL}payment-response';
  static const String OrderHistory = '${BASE_URL}orderhistory.php';

  static const String State = '${BASE_URL}state';
  static const String City = '${BASE_URL}city';
  static const String AddAddress = '${BASE_URL}add-address';
  static const String GetAddress = '${BASE_URL}myaddress.php';

  static const String GetSection = '${BASE_URL}section.php';

  // Webview urls
  static const String HOTCASE = 'http://www.combojumbo.in/cj-hotcase/';
  static const String MUNCHBOX =
      'https://www.combojumbo.in/cj-hotcase/index#munchbox';
}
