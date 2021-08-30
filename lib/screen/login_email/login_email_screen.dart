import 'package:cjspoton/screen/forgot_password/forgot_password_screen.dart';
import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:cjspoton/screen/register/register_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext.dart';
import 'package:cjspoton/widgets/icon_text_button.dart';
import 'package:cjspoton/widgets/password_edittext.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({Key? key}) : super(key: key);
  static const String EMAIL_LOGIN_ROUTE = '/emailLogin';
  @override
  _LoginEmailScreenState createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  late VideoPlayerController _controller;
  late Size screenSize;
  TextEditingController _passwordCtrl = TextEditingController();
  TextEditingController _emaildCtrl = TextEditingController();
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/videos/background.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool _isPasswordHidden = true;
  _togglePasswordVisibility() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: body(),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
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
                CustomTextField(
                  teCtrl: _emaildCtrl,
                  hint: 'Email',
                  inputType: TextInputType.emailAddress,
                ),
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
                      Navigator.of(context).pushNamed(
                          OtpVerificationScreen.OTP_VERIFICATION_ROUTE,
                          arguments: 'LoginEmailScreen');
                    },
                    child: Text(
                      'Login',
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
                    onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                        RegisterScreen.REGISTER_ROUTE, (route) => false),
                    child: Text(
                      'New to Combo Jumbo, register',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'By continuing, you agree our',
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Terms of Service',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Privacy Policy',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
