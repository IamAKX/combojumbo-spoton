import 'dart:io';

import 'package:cjspoton/screen/forgot_password/forgot_password_screen.dart';
import 'package:cjspoton/screen/login_email/login_email_screen.dart';
import 'package:cjspoton/screen/main_container_ios_specific/main_container_ios_specific.dart';
import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:cjspoton/screen/privacy_policy/privacy_policy_screen.dart';
import 'package:cjspoton/screen/register/register_screen.dart';
import 'package:cjspoton/screen/term_of_use/term_of_use_screen.dart';
import 'package:cjspoton/services/auth_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/agreement_footer.dart';
import 'package:cjspoton/widgets/icon_text_button.dart';
import 'package:cjspoton/widgets/password_edittext.dart';
import 'package:cjspoton/widgets/phone_edittext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String LOGIN_ROUTE = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late VideoPlayerController _controller;
  late Size screenSize;
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _passwordCtrl = TextEditingController();
  late AuthenticationService _auth;
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/videos/background_2.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  bool _isPasswordHidden = true;
  _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthenticationService>(context);
    return Scaffold(
      body: body(),
      resizeToAvoidBottomInset: false,
    );
  }

  body() {
    screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
          width: _controller.value.size.width,
          height: screenSize.height,
          child: VideoPlayer(_controller),
        ),
        Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.black54,
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding * 2),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Platform.isIOS
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () => _auth
                                    .saveDefaultOutlet(context)
                                    .then((value) => Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            MainContainerIosSpecific
                                                .MAIN_CONTAINER_IOS_SPECIFIC_ROUTE,
                                            (route) => false,
                                            arguments: 0)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    'Skip Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 40,
                            ),
                      Text(
                        'Welcome Back',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Sign in to continue',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        height: defaultPadding * 4,
                      ),
                      PhoneTextField(phoneCtrl: _phoneCtrl),
                      PasswordTextField(
                          passwordCtrl: _passwordCtrl,
                          isPasswordVisible: _isPasswordHidden,
                          tooglePasswordVisibility: _togglePasswordVisibility),
                      Container(
                        margin: EdgeInsets.only(bottom: defaultPadding),
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                ForgotPasswordScreen.FORGOT_PASSWORD_ROUTE);
                          },
                          child: Text(
                            'Forgot password?',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenSize.width,
                        child: TextButton(
                          onPressed: () {
                            if (_auth.status != AuthStatus.Authenticating)
                              _auth.loginUserWithPhoneAndPassword(
                                  _phoneCtrl.text, _passwordCtrl.text, context);
                          },
                          child: Text(
                            _auth.status == AuthStatus.Authenticating
                                ? 'Please wait...'
                                : 'Login Now!',
                            style: Theme.of(context).textTheme.button?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: defaultPadding, top: defaultPadding * 1.5),
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamedAndRemoveUntil(
                                  RegisterScreen.REGISTER_ROUTE,
                                  (route) => false),
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Sign Up',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              height: 1,
                              color: hintColor.withOpacity(0.5),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 15,
                            child: Text(
                              'OR',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              height: 1,
                              color: hintColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      IconTextButton(
                        context: context,
                        iconAssetPath: 'assets/svg/facebook.svg',
                        onTap: () {
                          if (_auth.status != AuthStatus.Authenticating)
                            _auth.registerUserWithFacebook(context);
                        },
                        text: _auth.status != AuthStatus.Authenticating
                            ? 'Continue with Facebook'
                            : 'Please wait...',
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      IconTextButton(
                        context: context,
                        iconAssetPath: 'assets/svg/google.svg',
                        onTap: () {
                          if (_auth.status != AuthStatus.Authenticating)
                            _auth.registerUserWithGoogle(context);
                        },
                        text: _auth.status != AuthStatus.Authenticating
                            ? 'Continue with Google'
                            : 'Please wait...',
                      ),
                    ],
                  ),
                ),
                AgreementFooter(context: context),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
