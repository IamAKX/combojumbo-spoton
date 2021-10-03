import 'dart:convert';
import 'dart:developer';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/outlet_model.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/choose_outlet/choose_outlet_screen.dart';
import 'package:cjspoton/screen/forgot_password/forgot_password_screen.dart';
import 'package:cjspoton/screen/introduction/introduction.dart';
import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:cjspoton/screen/reset_password/reset_password_screen.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:universal_internet_checker/universal_internet_checker.dart';

enum AuthStatus {
  NotAuthenticated,
  Authenticating,
  Authenticated,
  Error,
  ForgotPwdOtpSent
}

class AuthenticationService extends ChangeNotifier {
  static AuthenticationService instance = AuthenticationService();
  late FirebaseAuth _auth;
  late Dio _dio;
  AuthStatus? status = AuthStatus.NotAuthenticated;
  AuthenticationService() {
    _auth = FirebaseAuth.instance;
    _dio = Dio();
  }

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleSignInAccount;
  GoogleSignInAccount get googleSignInAccount => _googleSignInAccount!;

  Future registerUserWithGoogle(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      SnackBarService.instance.showSnackBarError('Login failed');
      return;
    }
    _googleSignInAccount = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    status = AuthStatus.Authenticating;
    notifyListeners();
    // try {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    var reqBody = FormData.fromMap({
      'name': _googleSignInAccount!.displayName,
      'email': _googleSignInAccount!.email,
      // 'g_id': _googleSignInAccount!.id,
      'g_id': googleAuth.accessToken,
      'mobileid': fcmToken,
      'profileImage': googleSignInAccount.photoUrl ?? ''
    });
    log('Request : ${reqBody.fields}');
    Response response = await _dio.post(
      API.GoogleRegisteration,
      data: reqBody,
    );
    if (response.statusCode == 200) {
      print('Response : ${response.data}');
      var responseBody = json.decode(response.data);
      var body = responseBody['body'];
      if (responseBody['status'] == 1) {
        UserModel userModel = UserModel(
            id: body['user_id'],
            name: googleSignInAccount.displayName!,
            phone: '',
            token: '',
            email: body['email'],
            fcmToken: fcmToken!,
            profileImage: body['image'] ?? '');

        prefs.setString(PrefernceKey.USER, userModel.toJson());
        prefs.setBool(PrefernceKey.IS_LOGGEDIN, true);

        await saveDefaultOutlet(context);
        status = AuthStatus.Authenticated;
        notifyListeners();
        // SnackBarService.instance.showSnackBarSuccess(body['msg']);

        if (body['is_new_user'] == 'Y')
          Navigator.of(context).pushNamed(Introduction.INTRODUCTION_ROUTE);
        else
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainContainer.MAIN_CONTAINER_ROUTE, (route) => false,
              arguments: 0);
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance.showSnackBarError((body['msg']));
      }
    } else {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance
          .showSnackBarError('Error : ${response.statusMessage!}');
    }
    // } catch (e) {
    //   status = AuthStatus.Error;
    //   notifyListeners();
    //   SnackBarService.instance.showSnackBarError(e.toString());
    // }
  }

  Future registerUserWithFacebook(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    // final FacebookLoginResult result =
    //     await facebookLogin.logIn(['email', 'public_profile']);
    // late User _facebookUser;
    // switch (result.status) {
    //   case FacebookLoginStatus.cancelledByUser:
    //     SnackBarService.instance.showSnackBarError('Cancelled by user');
    //     return;
    //   case FacebookLoginStatus.error:
    //     SnackBarService.instance.showSnackBarError('Sign in error');
    //     return;
    //   case FacebookLoginStatus.loggedIn:
    //     try {
    //       final FacebookAccessToken accessToken = result.accessToken;
    //       AuthCredential credential =
    //           FacebookAuthProvider.credential(accessToken.token);
    //       var userCred = await _auth.signInWithCredential(credential);
    //       if (userCred.user == null) {
    //         SnackBarService.instance.showSnackBarError('No user found');
    //         return;
    //       }
    //       _facebookUser = userCred.user!;
    //     } catch (e) {
    //       SnackBarService.instance.showSnackBarError(e.toString());
    //       return;
    //     }
    //     break;
    // }
    var _accessToken = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email'],
    );
    // _printCredentials(_accessToken);
    Map<String, dynamic> _facebookUser =
        await FacebookAuth.instance.getUserData();
    print('Facebook data : ${prettyPrint(_facebookUser)}');
    status = AuthStatus.Authenticating;
    notifyListeners();
    if (_facebookUser == null ||
        _facebookUser['name'] == null ||
        _facebookUser['email'] == null ||
        _facebookUser['name'].toString().isEmpty ||
        _facebookUser['email'].toString().isEmpty) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(
          'Unable to fetch your details. Please login with another source.');
      return;
    }

    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      var reqBody = FormData.fromMap({
        'fb_name': _facebookUser['name'],
        'fb_email':
            _facebookUser['email'] == null ? '' : _facebookUser['email'],
        'fb_id': _facebookUser['id'],
        'mobileid': fcmToken,
        'profileImage': _facebookUser['picture']['data']['url']
      });

      log(reqBody.fields.toString());
      Response response = await _dio.post(
        API.FacebookRegisteration,
        data: reqBody,
      );
      var responseBody = json.decode(response.data);
      if (response.statusCode == 200) {
        log('Response : ${response.data}');
        var body = responseBody['body'];
        if (responseBody['status'] == 1) {
          print('inside if');
          UserModel userModel = UserModel(
              id: body['user_id'],
              name: _facebookUser['name'] ?? '',
              phone: _facebookUser['phone'] ?? '',
              token: '',
              fcmToken: fcmToken ?? '',
              email: _facebookUser['email'] ?? '',
              profileImage: body['image'] ?? '');
          print(userModel);
          prefs.setBool(PrefernceKey.IS_LOGGEDIN, true);

          prefs.setString(PrefernceKey.USER, userModel.toJson());
          await saveDefaultOutlet(context);
          status = AuthStatus.Authenticated;
          notifyListeners();
          // SnackBarService.instance.showSnackBarSuccess(body['msg']);
          if (body['is_new_user'] == 'Y')
            Navigator.of(context).pushNamed(Introduction.INTRODUCTION_ROUTE);
          else
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainContainer.MAIN_CONTAINER_ROUTE, (route) => false,
                arguments: 0);
        } else {
          status = AuthStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<void> registerUserWithPhoneAndPassword(
      String name, String phone, String password, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    status = AuthStatus.Authenticating;
    notifyListeners();
    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      status = AuthStatus.Error;
      SnackBarService.instance.showSnackBarError('All fields are mandatory');
      return;
    }
    if (!Utilities().isValidPassword(password)) {
      status = AuthStatus.Error;
      return;
    }
    if (phone.length != 10) {
      status = AuthStatus.Error;
      SnackBarService.instance.showSnackBarError('Invalid phone number');
      return;
    }
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      var reqBody = FormData.fromMap({
        'name': name,
        'contact': phone,
        'password': password,
        'mobileid': fcmToken
      });

      Response response = await _dio.post(
        API.PhoneRegisteration,
        data: reqBody,
      );
      print('Request : ${reqBody.fields}');
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          UserModel userModel = UserModel(
              id: body['user_id'],
              name: name,
              phone: phone,
              token: body['token'],
              fcmToken: fcmToken!,
              email: '',
              profileImage: '');

          prefs.setString(PrefernceKey.USER, userModel.toJson());
          await saveDefaultOutlet(context);
          status = AuthStatus.Authenticated;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess(body['msg']);
          Navigator.of(context).pushNamed(
              OtpVerificationScreen.OTP_VERIFICATION_ROUTE,
              arguments: 'RegisterScreen');
        } else {
          status = AuthStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<void> loginUserWithPhoneAndPassword(
      String phone, String password, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    status = AuthStatus.Authenticating;
    notifyListeners();
    if (phone.isEmpty || password.isEmpty) {
      status = AuthStatus.Error;
      SnackBarService.instance.showSnackBarError('All fields are mandatory');
      return;
    }
    if (phone.length != 10) {
      status = AuthStatus.Error;
      SnackBarService.instance.showSnackBarError('Invalid phone number');
      return;
    }
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      var reqBody = FormData.fromMap({
        'username': phone,
        'password': password,
        'mobileid': fcmToken,
      });

      Response response = await _dio.post(
        API.PhoneLogin,
        data: reqBody,
      );
      print('Request : ${reqBody.fields}');
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data.toString().trim()}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          UserModel userModel = UserModel(
              id: body['user_id'],
              name: body['name'],
              phone: phone,
              token: body['token'] == null ? '' : body['token'],
              fcmToken: fcmToken!,
              email: body['email'],
              profileImage: body['image']);

          prefs.setString(PrefernceKey.USER, userModel.toJson());
          await saveDefaultOutlet(context);
          prefs.setBool(PrefernceKey.IS_LOGGEDIN, true);
          status = AuthStatus.Authenticated;
          notifyListeners();
          // SnackBarService.instance.showSnackBarSuccess(body['msg']);
          Navigator.of(context).pushNamedAndRemoveUntil(
              MainContainer.MAIN_CONTAINER_ROUTE, (route) => false,
              arguments: 0);
        } else {
          status = AuthStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<void> verifyOTP(
      String otp, String currentScreen, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    status = AuthStatus.Authenticating;
    notifyListeners();
    if (otp.isEmpty) {
      status = AuthStatus.Error;
      SnackBarService.instance.showSnackBarError('All fields are mandatory');
      return;
    }

    try {
      UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({
        'otp': otp,
        'cust_id': user.id,
      });
      String api = currentScreen == 'ForgotPasswordScreen'
          ? API.ForgotPasswordVerifyOTP
          : API.VerifyOTP;
      Response response = await _dio.post(
        api,
        data: reqBody,
      );
      print('Request : ${reqBody.fields}');
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          status = AuthStatus.Authenticated;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess(body['msg']);
          if (currentScreen == 'RegisterScreen' ||
              currentScreen == 'LoginScreen')
            Navigator.of(context).pushNamedAndRemoveUntil(
                Introduction.INTRODUCTION_ROUTE, (route) => false);
          else if (currentScreen == 'ForgotPasswordScreen')
            Navigator.of(context)
                .pushNamed(ResetPasswordScreen.RESET_PASSWORD_ROUTE);
          else {
            prefs.setBool(PrefernceKey.IS_LOGGEDIN, true);
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainContainer.MAIN_CONTAINER_ROUTE, (route) => false,
                arguments: 0);
          }
        } else {
          status = AuthStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<void> resendOTP(String currentScreen, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    status = AuthStatus.Authenticating;
    notifyListeners();

    try {
      UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({
        'cust_id': user.id,
      });
      String api = currentScreen == 'ForgotPasswordScreen'
          ? API.ForgotPasswordResendOTP
          : API.ResendOTP;
      Response response = await _dio.post(
        api,
        data: reqBody,
      );
      print('Request : ${reqBody.fields}');
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          status = AuthStatus.Authenticated;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess(body['msg']);
        } else {
          status = AuthStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<void> forgotPassword(String phone, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    status = AuthStatus.Authenticating;
    notifyListeners();
    if (phone.isEmpty) {
      status = AuthStatus.Error;
      SnackBarService.instance.showSnackBarError('All fields are mandatory');
      return;
    }
    if (phone.length != 10) {
      status = AuthStatus.Error;
      SnackBarService.instance.showSnackBarError('Invalid phone number');
      return;
    }
    try {
      var reqBody = FormData.fromMap({
        'contact': phone,
      });

      Response response = await _dio.post(
        API.ForgotPassword,
        data: reqBody,
      );
      print('Request : ${reqBody.fields}');
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          status = AuthStatus.Authenticated;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess(body['msg']);
          UserModel userModel = UserModel(
              id: body['user_id'],
              name: body['name'],
              phone: phone,
              token: body['token'] == null ? '' : body['token'],
              fcmToken: '',
              email: '',
              profileImage: '');

          prefs.setString(PrefernceKey.USER, userModel.toJson());
          Navigator.of(context).pushNamed(
              OtpVerificationScreen.OTP_VERIFICATION_ROUTE,
              arguments: 'ForgotPasswordScreen');
        } else {
          status = AuthStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<void> resetPassword(
      String newPassword, String confPassword, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    if (newPassword.isEmpty || confPassword.isEmpty) {
      SnackBarService.instance.showSnackBarError('All fields are mandatory');
      return;
    }
    if (newPassword != confPassword) {
      SnackBarService.instance.showSnackBarError(
          'New password and Confirm Password is not matching');
      return;
    }

    if (!Utilities().isValidPassword(confPassword)) {
      status = AuthStatus.Error;
      return;
    }

    status = AuthStatus.Authenticating;
    notifyListeners();

    try {
      UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({
        'cust_id': user.id,
        'password': newPassword,
        'confirm_password': confPassword,
      });

      Response response = await _dio.post(
        API.ResetPassword,
        data: reqBody,
      );
      print('Request : ${reqBody.fields}');
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          status = AuthStatus.Authenticated;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess(body['msg']);
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.LOGIN_ROUTE, (route) => false);
        } else {
          status = AuthStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword,
      String confPassword, BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    if (newPassword.isEmpty || confPassword.isEmpty || oldPassword.isEmpty) {
      SnackBarService.instance.showSnackBarError('All fields are mandatory');
      return;
    }
    if (newPassword != confPassword) {
      SnackBarService.instance.showSnackBarError(
          'New password and Confirm Password is not matching');
      return;
    }
    if (!Utilities().isValidPassword(confPassword)) {
      status = AuthStatus.Error;
      return;
    }

    status = AuthStatus.Authenticating;
    notifyListeners();

    try {
      UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({
        'cust_id': user.id,
        'password': newPassword,
        'confirm_password': confPassword,
        'oldpassword': oldPassword
      });

      Response response = await _dio.post(
        API.ChangePassword,
        data: reqBody,
      );
      print('Request : ${reqBody.fields}');
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 0) {
          status = AuthStatus.Authenticated;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess(body['msg']);
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     LoginScreen.LOGIN_ROUTE, (route) => false);
        } else {
          status = AuthStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }

  Future<void> saveDefaultOutlet(BuildContext context) async {
    ConnectionStatus connectionStatus =
        await UniversalInternetChecker.checkInternet();
    if (connectionStatus == ConnectionStatus.offline ||
        connectionStatus == ConnectionStatus.unknown) {
      SnackBarService.instance
          .showSnackBarError('You are not connected to internet');
      return;
    }
    status = AuthStatus.Authenticating;
    notifyListeners();
    List<OutletModel> list = [];
    try {
      Response response = await _dio.post(
        API.Outlets,
      );

      log(response.data);
      var resBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          for (var outlet in body) {
            OutletModel outletModel = OutletModel(
                outletId: outlet['OutletId'],
                outletName: outlet['OutletName'],
                address: outlet['Address'],
                image: outlet['Image']);
            list.add(outletModel);
          }

          if (list.isEmpty) {
            status = AuthStatus.Error;
            SnackBarService.instance
                .showSnackBarError('Unable to fetch outlet details');
          } else {
            await prefs.setString(
                PrefernceKey.SELECTED_OUTLET, list.first.toJson());
            status = AuthStatus.Authenticated;
          }
          log(prefs.getKeys().toString());
          notifyListeners();
        } else {
          status = AuthStatus.Error;
          notifyListeners();
          SnackBarService.instance.showSnackBarError((body['msg']));
        }
      } else {
        status = AuthStatus.Error;
        notifyListeners();
        SnackBarService.instance
            .showSnackBarError('Error : ${response.statusMessage!}');
      }
    } catch (e) {
      status = AuthStatus.Error;
      notifyListeners();
      SnackBarService.instance.showSnackBarError(e.toString());
    }
  }
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

void _printCredentials(var _accessToken) {
  print(
    prettyPrint(_accessToken.toJson()),
  );
}
