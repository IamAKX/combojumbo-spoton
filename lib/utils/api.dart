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

  static const String Profile = '${BASE_URL}myprofile.php';

  static const String Outlets = '${BASE_URL}outlet.php';
}
