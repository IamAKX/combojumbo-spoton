import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/custom_edittext_with_heading%20copy.dart';
import 'package:cjspoton/widgets/phone_edittext_with_heading.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);
  static const String UPDATE_PROFILE_ROUTE = '/updateProfileRoute';

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController _nameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  late UserModel user;
  @override
  Widget build(BuildContext context) {
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
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user.profileImage.isEmpty
                  ? 'https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2978&q=80'
                  : user.profileImage),
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
                onPressed: () {},
                child: Text(
                  'Update Profile',
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
