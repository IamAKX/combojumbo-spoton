import 'dart:io';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
  TextEditingController _imageAttachment = TextEditingController();
  File? imageFile = null;

  UserModel user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
  late ProfileManagementService _profileManagementService;
  @override
  Widget build(BuildContext context) {
    _profileManagementService = Provider.of<ProfileManagementService>(context);
    SnackBarService.instance.buildContext = context;
    _nameCtrl.text = user.name;
    _emailCtrl.text = user.email;
    _phoneCtrl.text = user.phone;
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
                    teCtrl: _phoneCtrl,
                    hint: 'Phone',
                    inputType: TextInputType.phone),
                InkWell(
                  onTap: () async {
                    if (await Permission.storage.request().isGranted) {
                      // Either the permission was already granted before or the user just granted it.
                      pickImage();
                    } else {
                      SnackBarService.instance.showSnackBarError(
                          'Please grant storage permission to access gallery image');
                    }
                  },
                  child: CustomTextFieldWithHeading(
                    teCtrl: _imageAttachment,
                    hint: 'Attach Image',
                    inputType: TextInputType.text,
                    enabled: false,
                  ),
                ),
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
              onPressed:
                  _profileManagementService.status == ProfileStatus.Loading
                      ? null
                      : () {
                          _profileManagementService.sendFeedback(
                            _nameCtrl.text,
                            _emailCtrl.text,
                            _phoneCtrl.text,
                            _feedBackCtrl.text,
                            context,
                            imageFile,
                          );
                        },
              child: Text(
                _profileManagementService.status == ProfileStatus.Loading
                    ? 'Loading...'
                    : 'Submit',
                style: Theme.of(context)
                    .textTheme
                    .button
                    ?.copyWith(color: bgColor),
              ),
            ),
          ),
          SizedBox(
            height: defaultPadding * 2,
          ),
        ],
      )),
    );
  }

  pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      _imageAttachment.text = basename(image.path);
    }
  }
}
