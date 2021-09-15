import 'package:cjspoton/utils/colors.dart';
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
      child: Container(
        decoration: BoxDecoration(
            color: Colors.amber[100], borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                '+91',
                style: Theme.of(context).textTheme.subtitle1,
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
