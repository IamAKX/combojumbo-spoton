import 'dart:io';

import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:cjspoton/widgets/phone_edittext_with_heading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);
  static const String UPDATE_PROFILE_ROUTE = '/updateProfileRoute';

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late ProfileManagementService _profileManagementService;

  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  File? imageFile = null;
  late UserModel user;

  pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _profileManagementService = Provider.of<ProfileManagementService>(context);
    SnackBarService.instance.buildContext = context;
    user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    _nameCtrl.text = user.name;
    _emailCtrl.text = user.email;
    _phoneCtrl.text = user.phone;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: ListView(
          children: [
            InkWell(
              onTap: () => pickProfileImage(),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: imageFile == null
                    ? NetworkImage(user.profileImage.isEmpty
                        ? 'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2978&q=80'
                        : user.profileImage)
                    : FileImage(imageFile!) as ImageProvider,
              ),
            ),
            CustomTextFieldWithHeading(
              teCtrl: _nameCtrl,
              hint: 'Name',
              inputType: TextInputType.name,
            ),
            CustomTextFieldWithHeading(
              teCtrl: _emailCtrl,
              hint: 'Email',
              inputType: TextInputType.emailAddress,
            ),
            PhoneTextFieldWithHeading(
              phoneCtrl: _phoneCtrl,
              hint: 'Phone Number',
            ),
            SizedBox(
              height: defaultPadding,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed:
                    _profileManagementService.status == ProfileStatus.Loading
                        ? null
                        : () {
                            _profileManagementService.updateProfile(
                                _nameCtrl.text,
                                _emailCtrl.text,
                                _phoneCtrl.text,
                                imageFile,
                                context);
                          },
                child: Text(
                  _profileManagementService.status == ProfileStatus.Loading
                      ? 'Loading...'
                      : 'Update Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}