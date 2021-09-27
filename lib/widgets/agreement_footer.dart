import 'package:cjspoton/screen/privacy_policy/privacy_policy_screen.dart';
import 'package:cjspoton/screen/term_of_use/term_of_use_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

class AgreementFooter extends StatelessWidget {
  const AgreementFooter({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: defaultPadding,
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            'By continuing, your agree our',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(TermOfUseSceen.TERMS_ROUTE);
              },
              child: Text(
                'Terms of Service',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(decoration: TextDecoration.underline),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              color: borderColor,
              height: 10,
              width: 2,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(PrivacyPolicyScreen.PRIVACY_ROUTE);
              },
              child: Text(
                'Privacy Policy',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
      ],
    );
  }
}
