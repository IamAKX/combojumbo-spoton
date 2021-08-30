import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:cjspoton/services/auth_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext.dart';
import 'package:cjspoton/widgets/icon_text_button.dart';
import 'package:cjspoton/widgets/password_edittext.dart';
import 'package:cjspoton/widgets/phone_edittext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String REGISTER_ROUTE = '/register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late VideoPlayerController _controller;
  late Size screenSize;
  bool agreement = false;
  late AuthenticationService _auth;
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _passwordCtrl = TextEditingController();
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
    SnackBarService.instance.buildContext = context;
    _auth = Provider.of<AuthenticationService>(context);
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
              children: [
                Expanded(
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Welcome',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Register to continue',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        height: defaultPadding * 4,
                      ),
                      CustomTextField(
                        teCtrl: _nameCtrl,
                        hint: 'Name',
                        inputType: TextInputType.name,
                      ),
                      PhoneTextField(phoneCtrl: _phoneCtrl),
                      PasswordTextField(
                          passwordCtrl: _passwordCtrl,
                          isPasswordVisible: _isPasswordHidden,
                          tooglePasswordVisibility: _togglePasswordVisibility),
                      Row(
                        children: [
                          Theme(
                            data: Theme.of(context)
                                .copyWith(unselectedWidgetColor: hintColor),
                            child: Checkbox(
                              value: agreement,
                              onChanged: (value) {
                                setState(() {
                                  agreement = !agreement;
                                });
                              },
                            ),
                          ),
                          Text(
                            'I agree all terms and conditions',
                            style: TextStyle(color: bgColor),
                          ),
                        ],
                      ),
                      SizedBox(height: defaultPadding * 0.5),
                      SizedBox(
                        width: screenSize.width,
                        child: TextButton(
                          onPressed: _auth.status == AuthStatus.Authenticating
                              ? null
                              : () {
                                  if (agreement)
                                    _auth.registerUserWithPhoneAndPassword(
                                        _nameCtrl.text,
                                        _phoneCtrl.text,
                                        _passwordCtrl.text,
                                        context);
                                  else
                                    SnackBarService.instance.showSnackBarError(
                                        'Accept terms and conditions');
                                },
                          child: Text(
                            _auth.status == AuthStatus.Authenticating
                                ? 'Please wait...'
                                : 'Register',
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
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                LoginScreen.LOGIN_ROUTE, (route) => false);
                          },
                          child: Text(
                            'Old user of Combo Jumbo, login',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
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
                SizedBox(
                  height: defaultPadding,
                ),
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
