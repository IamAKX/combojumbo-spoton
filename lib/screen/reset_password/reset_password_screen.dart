import 'package:cjspoton/services/auth_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/password_edittext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);
  static const String RESET_PASSWORD_ROUTE = '/resetPassword';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late AuthenticationService _auth;
  TextEditingController _newPasswordCtrl = TextEditingController();
  TextEditingController _confPasswordCtrl = TextEditingController();

  bool _isNewPassHidden = true;
  bool _isConfPassHidden = true;

  _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPassHidden = !_isNewPassHidden;
    });
  }

  _toggleConfPasswordVisibility() {
    setState(() {
      _isConfPassHidden = !_isConfPassHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationService>(context);
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.all(
          defaultPadding,
        ),
        children: [
          PasswordTextField(
            passwordCtrl: _newPasswordCtrl,
            isPasswordVisible: _isNewPassHidden,
            tooglePasswordVisibility: _toggleNewPasswordVisibility,
            hint: 'New Password',
          ),
          PasswordTextField(
            passwordCtrl: _confPasswordCtrl,
            isPasswordVisible: _isConfPassHidden,
            tooglePasswordVisibility: _toggleConfPasswordVisibility,
            hint: 'Confirm Password',
          ),
          SizedBox(
            height: defaultPadding,
          ),
          TextButton(
            onPressed: _auth.status == AuthStatus.Authenticating
                ? null
                : () {
                    _auth.resetPassword(
                        _newPasswordCtrl.text, _confPasswordCtrl.text, context);
                  },
            child: Text(
              _auth.status == AuthStatus.Authenticating
                  ? 'Please wait...'
                  : 'Change Password',
              style: Theme.of(context).textTheme.button?.copyWith(
                    color: Colors.white,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
