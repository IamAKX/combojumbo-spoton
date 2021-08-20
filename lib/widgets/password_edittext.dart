import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    Key? key,
    required TextEditingController passwordCtrl,
    required this.isPasswordVisible,
    required this.tooglePasswordVisibility,
    this.hint,
  })  : _passwordCtrl = passwordCtrl,
        super(key: key);

  final TextEditingController _passwordCtrl;
  final bool isPasswordVisible;
  final Function() tooglePasswordVisibility;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: TextField(
        keyboardType: TextInputType.visiblePassword,
        autocorrect: true,
        obscureText: isPasswordVisible,
        controller: _passwordCtrl,
        decoration: InputDecoration(
          hintText: hint == null ? 'Password' : hint,
          counterText: "",
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: tooglePasswordVisibility,
          ),
        ),
      ),
    );
  }
}
