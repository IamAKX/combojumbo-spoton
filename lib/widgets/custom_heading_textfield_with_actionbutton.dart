import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class CustomTextFieldWithHeadingActionButton extends StatelessWidget {
  const CustomTextFieldWithHeadingActionButton({
    Key? key,
    required TextEditingController teCtrl,
    required this.hint,
    required this.inputType,
    required this.icondata,
    required this.onTap,
    this.enabled,
  })  : _teCtrl = teCtrl,
        super(key: key);

  final TextEditingController _teCtrl;
  final String hint;
  final TextInputType inputType;
  final IconData icondata;
  final Function() onTap;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hint,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          TextField(
            keyboardType: inputType,
            enabled: enabled ?? true,
            autocorrect: true,
            controller: _teCtrl,
            textCapitalization: inputType == TextInputType.name
                ? TextCapitalization.words
                : TextCapitalization.sentences,
            decoration: InputDecoration(
              suffixIcon: IconButton(onPressed: onTap, icon: Icon(icondata)),
              hintText: hint,
              focusColor: primaryColor,
              alignLabelWithHint: false,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: defaultPadding),
              hoverColor: primaryColor,
              hintStyle: TextStyle(color: hintColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
