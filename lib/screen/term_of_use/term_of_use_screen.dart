import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/static_data.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TermOfUseSceen extends StatefulWidget {
  const TermOfUseSceen({Key? key}) : super(key: key);
  static const String TERMS_ROUTE = '/termsOfUse';

  @override
  _TermOfUseSceenState createState() => _TermOfUseSceenState();
}

class _TermOfUseSceenState extends State<TermOfUseSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyedBgColor,
      appBar: AppBar(
        title: Text('Terms of Service'),
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
              data: TERMS_OF_USE,
            ),
          ),
        ),
      ),
    );
  }
}
