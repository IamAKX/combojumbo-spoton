import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({
    Key? key,
    required TextEditingController phoneCtrl,
  })  : _phoneCtrl = phoneCtrl,
        super(key: key);

  final TextEditingController _phoneCtrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: TextField(
        keyboardType: TextInputType.phone,
        autocorrect: true,
        controller: _phoneCtrl,
        maxLength: 10,
        decoration: InputDecoration(
          hintText: 'Phone Number',
          prefixText: '+91  ',
          counterText: "",
        ),
      ),
    );
  }
}
