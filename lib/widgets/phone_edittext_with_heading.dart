import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class PhoneTextFieldWithHeading extends StatelessWidget {
  const PhoneTextFieldWithHeading({
    Key? key,
    required TextEditingController phoneCtrl,
    required this.hint,
  })  : _phoneCtrl = phoneCtrl,
        super(key: key);

  final TextEditingController _phoneCtrl;
  final String hint;

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
          Row(
            children: [
              Container(
                height: 49,
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  '+91',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.phone,
                  autocorrect: true,
                  controller: _phoneCtrl,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: 'Mobile',
                    counterText: "",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: defaultPadding),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                          topRight: Radius.circular(4)),
                      borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                          topRight: Radius.circular(4)),
                      borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                          topRight: Radius.circular(4)),
                      borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
