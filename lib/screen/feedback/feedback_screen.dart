import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);
  static const String FEEDBACK_ROUTE = '/feedbackScreen';

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _feedBackCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyedBgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        centerTitle: false,
        title: Text('Report a Problem'),
      ),
      body: SafeArea(
          child: ListView(
        children: [
          SizedBox(
            height: defaultPadding,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFieldWithHeading(
                    teCtrl: _nameCtrl,
                    hint: 'Name',
                    inputType: TextInputType.name),
                CustomTextFieldWithHeading(
                    teCtrl: _emailCtrl,
                    hint: 'Email Address',
                    inputType: TextInputType.emailAddress),
                CustomTextFieldWithHeading(
                    teCtrl: _nameCtrl,
                    hint: 'Phone',
                    inputType: TextInputType.phone),
                Text(
                  'How can we help you?',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  controller: _feedBackCtrl,
                  decoration: InputDecoration(
                    hintText: 'Hi there, I would like to...',
                    focusColor: primaryColor,
                    alignLabelWithHint: false,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: defaultPadding, vertical: defaultPadding),
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'SUBMIT',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          )
        ],
      )),
    );
  }
}
