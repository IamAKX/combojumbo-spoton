import 'package:cjspoton/screen/register/register_screen.dart';
import 'package:cjspoton/services/auth_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/agreement_footer.dart';
import 'package:cjspoton/widgets/phone_edittext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  late AuthenticationService _auth;
  TextEditingController _phoneCtrl = TextEditingController();
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset("assets/videos/background_2.mp4")
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Forgot Password',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.white),
                ),
                Text(
                  'Please enter your registered mobile number',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(color: Colors.white),
                ),
                SizedBox(
                  height: defaultPadding * 4,
                ),
                PhoneTextField(phoneCtrl: _phoneCtrl),
                SizedBox(
                  width: screenSize.width,
                  child: TextButton(
                    onPressed: () {
                      if (_auth.status != AuthStatus.Authenticating)
                        _auth.forgotPassword(_phoneCtrl.text, context);
                    },
                    child: Text(
                      _auth.status != AuthStatus.Authenticating
                          ? 'Send OTP'
                          : 'Please wait...',
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
                Spacer(),
                AgreementFooter(context: context)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
