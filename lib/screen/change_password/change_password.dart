import 'package:cjspoton/services/auth_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/password_edittext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  static const String CHANGE_PASSWORD_ROUTE = '/changePassword';

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late AuthenticationService _auth;
  TextEditingController _newPasswordCtrl = TextEditingController();
  TextEditingController _oldPasswordCtrl = TextEditingController();
  TextEditingController _confPasswordCtrl = TextEditingController();

  bool _isNewPassHidden = true;
  bool _isOldPassHidden = true;
  bool _isConfPassHidden = true;

  _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPassHidden = !_isNewPassHidden;
    });
  }

  _toggleOldPasswordVisibility() {
    setState(() {
      _isOldPassHidden = !_isOldPassHidden;
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
        title: Text('Change Password'),
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
            passwordCtrl: _oldPasswordCtrl,
            isPasswordVisible: _isOldPassHidden,
            tooglePasswordVisibility: _toggleOldPasswordVisibility,
            hint: 'Old Password',
          ),
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
            hint: 'Confirm New Password',
          ),
          SizedBox(
            height: defaultPadding,
          ),
          TextButton(
            onPressed: _auth.status == AuthStatus.Authenticating
                ? null
                : () {
                    _auth.changePassword(_oldPasswordCtrl.text,
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
