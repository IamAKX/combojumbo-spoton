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
  // static const String ForgotPasswordResendOTP = '${BASE_URL}resendotp.php';
  static const String ForgotPasswordResendOTP =
      '${BASE_URL}resendotp-forgot.php';
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
  static const String OfferHome = '${BASE_URL}offer';

  static const String State = '${BASE_URL}state';
  static const String City = '${BASE_URL}city';
  static const String AddAddress = '${BASE_URL}add-address';
  static const String DeleteAddress = '${BASE_URL}delete-address.php';
  static const String GetAddress = '${BASE_URL}myaddress.php';
  static const String UpdateAddress = '${BASE_URL}update-address';

  static const String GetSection = '${BASE_URL}section.php';
  static const String TableBookingOrderHistory = '${BASE_URL}table_history.php';

  static const String Feedback = '${BASE_URL}report';
  static const String OrderFeedback = '${BASE_URL}feedback.php';
  static const String ImageGallery = '${BASE_URL}gallerylist';
  static const String VideoGallery = '${BASE_URL}videolist';
  static const String FAQ = '${BASE_URL}faqlist';

  // Webview urls
  static const String HOTCASE = 'https://www.combojumbo.in/cj-hotcase/';
  static const String MUNCHBOX =
      'https://www.combojumbo.in/cj-hotcase/index#munchbox';
  static const String BANQUET_PPC = 'https://www.combojumbo.in/banquet-ppc/';

  // CJ-Spotons
  static const String AllTable = '${BASE_URL}tableapi';

  // Favourite
  static const String FavouriteList = '${BASE_URL}fav-list.php';
  static const String AddFavourite = '${BASE_URL}addfav.php';
  static const String RemoveFavourite = '${BASE_URL}removefav';
}
