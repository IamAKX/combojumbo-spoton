import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/static_data.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);
  static const String PRIVACY_ROUTE = '/privacy';

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyedBgColor,
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: bgColor,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(10)),
            width: double.infinity,
            margin: EdgeInsets.all(defaultPadding),
            child: Html(
              data: PRIVACY_POLICY,
            ),
          ),
        ),
      ),
    );
  }
}
