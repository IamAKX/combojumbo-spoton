import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:cjspoton/screen/register/register_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext.dart';
import 'package:cjspoton/widgets/icon_text_button.dart';
import 'package:cjspoton/widgets/password_edittext.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const String FORGOT_PASSWORD_ROUTE = '/forgotPassword';
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late VideoPlayerController _controller;
  late Size screenSize;
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
                Text(
                  'Forgot Password',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  'Password reset link will be sent to this email',
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
                SizedBox(
                  width: screenSize.width,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          OtpVerificationScreen.OTP_VERIFICATION_ROUTE);
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
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Content Policy',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(decoration: TextDecoration.underline),
                      ),
                    )
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
