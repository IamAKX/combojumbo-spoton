import 'dart:convert';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/forgot_password/forgot_password_screen.dart';
import 'package:cjspoton/screen/introduction/introduction.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  FacebookLogin facebookLogin = FacebookLogin();

  Future registerUserWithGoogle(BuildContext context) async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      SnackBarService.instance.showSnackBarError('Login failed');
      return;
    }
    _googleSignInAccount = googleUser;
    final googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);

    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      var reqBody = FormData.fromMap({
        'name': _googleSignInAccount!.displayName,
        'email': _googleSignInAccount!.email,
        'g_id': _googleSignInAccount!.id,
        'mobileid': fcmToken
      });
      print('Request : $reqBody');
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
              fcmToken: fcmToken!);

          prefs.setString(PrefernceKey.USER, userModel.toJson());
          status = AuthStatus.Authenticated;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess(body['msg']);
          Navigator.of(context).pushNamed(Introduction.INTRODUCTION_ROUTE);
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

  Future registerUserWithFacebook(BuildContext context) async {
    final FacebookLoginResult result =
        await facebookLogin.logIn(['email', 'public_profile']);
    late User _facebookUser;
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        SnackBarService.instance.showSnackBarError('Cancelled by user');
        return;
      case FacebookLoginStatus.error:
        SnackBarService.instance.showSnackBarError('Sign in error');
        return;
      case FacebookLoginStatus.loggedIn:
        try {
          final FacebookAccessToken accessToken = result.accessToken;
          AuthCredential credential =
              FacebookAuthProvider.credential(accessToken.token);
          var userCred = await _auth.signInWithCredential(credential);
          if (userCred.user == null) {
            SnackBarService.instance.showSnackBarError('No user found');
            return;
          }
          _facebookUser = userCred.user!;
        } catch (e) {
          SnackBarService.instance.showSnackBarError(e.toString());
          return;
        }
        break;
    }

    status = AuthStatus.Authenticating;
    notifyListeners();
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      var reqBody = FormData.fromMap({
        'fb_name': _facebookUser.displayName,
        'fb_email': _facebookUser.email == null ? '' : _facebookUser.email,
        'fb_id': _facebookUser.uid,
        'mobileid': fcmToken
      });
      print('Request : ${{
        'fb_name': _facebookUser.displayName,
        'fb_email': _facebookUser.email == null ? '' : _facebookUser.email,
        'fb_id': _facebookUser.uid,
        'mobileid': fcmToken
      }}');
      Response response = await _dio.post(
        API.FacebookRegisteration,
        data: reqBody,
      );
      var responseBody = json.decode(response.data);
      if (response.statusCode == 200) {
        print('Response : ${response.data}');
        var body = responseBody['body'];
        if (responseBody['status'] == 1) {
          UserModel userModel = UserModel(
              id: body['user_id'],
              name: _facebookUser.displayName!,
              phone: _facebookUser.phoneNumber!,
              token: '',
              fcmToken: fcmToken!,
              email: _facebookUser.email!);

          prefs.setString(PrefernceKey.USER, userModel.toJson());
          status = AuthStatus.Authenticated;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess(body['msg']);
          Navigator.of(context).pushNamed(Introduction.INTRODUCTION_ROUTE);
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
    status = AuthStatus.Authenticating;
    notifyListeners();
    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
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
              email: '');

          prefs.setString(PrefernceKey.USER, userModel.toJson());
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
        print('Response : ${response.data}');

        var body = resBody['body'];

        if (resBody['status'] == 1) {
          UserModel userModel = UserModel(
              id: body['user_id'],
              name: body['name'],
              phone: phone,
              token: body['token'],
              fcmToken: fcmToken!,
              email: '');

          prefs.setString(PrefernceKey.USER, userModel.toJson());
          status = AuthStatus.Authenticated;
          notifyListeners();
          SnackBarService.instance.showSnackBarSuccess(body['msg']);
          Navigator.of(context).pushNamed(MainContainer.MAIN_CONTAINER_ROUTE);
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

      Response response = await _dio.post(
        API.VerifyOTP,
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
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainContainer.MAIN_CONTAINER_ROUTE, (route) => false);
          else
            Navigator.of(context).pushNamedAndRemoveUntil(
                MainContainer.MAIN_CONTAINER_ROUTE, (route) => false);
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

  Future<void> resendOTP(BuildContext context) async {
    status = AuthStatus.Authenticating;
    notifyListeners();

    try {
      UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      var reqBody = FormData.fromMap({
        'cust_id': user.id,
      });

      Response response = await _dio.post(
        API.ResendOTP,
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
}
