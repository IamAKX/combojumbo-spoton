import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required TextEditingController teCtrl,
    required this.hint,
    required this.inputType,
  })  : _teCtrl = teCtrl,
        super(key: key);

  final TextEditingController _teCtrl;
  final String hint;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: TextField(
        textCapitalization: inputType == TextInputType.name
            ? TextCapitalization.words
            : TextCapitalization.sentences,
        keyboardType: inputType,
        autocorrect: true,
        controller: _teCtrl,
        decoration: InputDecoration(
          hintText: hint,
        ),
      ),
    );
  }
}
