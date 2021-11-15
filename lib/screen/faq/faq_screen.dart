import 'package:cjspoton/screen/faq/faq_model.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);
  static const String FAQ_ROUTE = '/FAQScreen';

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  late ProfileManagementService _profileManagementService;
  List<FAQModel> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => _profileManagementService.fetchFAQ(context).then(
        (value) {
          setState(() {
            list = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _profileManagementService = Provider.of<ProfileManagementService>(context);
    SnackBarService.instance.buildContext = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('FAQ'),
      ),
      body: _profileManagementService.status == ProfileStatus.Ideal
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _profileManagementService.status == ProfileStatus.Failed
              ? Center(
                  child: Text('FAQ is empty'),
                )
              : body(),
    );
  }

  body() {
    return ListView(
      children: [
        for (var faq in list) ...{
          Card(
            margin: EdgeInsets.all(8),
            elevation: 4,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: defaultPadding / 2),
                  child: Text(
                    faq.categoryname,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                for (var question in faq.faqlist) ...{
                  ExpansionTile(
                    tilePadding:
                        EdgeInsets.symmetric(horizontal: defaultPadding),
                    backgroundColor: bgColor,
                    title: Text(question.ques),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Text(
                          question.ans.trim() + "\n",
                        ),
                      ),
                    ],
                  ),
                },
              ],
            ),
          ),
        }
      ],
    );
  }
}
