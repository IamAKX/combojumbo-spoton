import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cjspoton/main.dart';
import 'package:cjspoton/model/user_model.dart';
import 'package:cjspoton/screen/add_delivery_addres/add_delivery_address_screen.dart';
import 'package:cjspoton/screen/all_address/all_address.dart';
import 'package:cjspoton/screen/change_password/change_password.dart';
import 'package:cjspoton/screen/feedback/feedback_screen.dart';
import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/screen/privacy_policy/privacy_policy_screen.dart';
import 'package:cjspoton/screen/reset_password/reset_password_screen.dart';
import 'package:cjspoton/screen/term_of_use/term_of_use_screen.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/update_profile/update_profile_screen.dart';
import 'package:cjspoton/utils/api.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/constants.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/widgets/webview_internal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SnackBarService.instance.buildContext = context;
    if (null != prefs.getString(PrefernceKey.USER))
      user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
    if (MainContainer.profileManagementService.status ==
        ProfileStatus.Success) {
      setState(() {
        if (null != prefs.getString(PrefernceKey.USER))
          user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
      });
    }
    MainContainer.profileManagementService.fetchProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          color: bgColor,
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.profileImage.isEmpty
                    ? 'http://www.ansonika.com/fooyes/img/avatar1.jpg'
                    : user.profileImage),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text('${user.email}\n${user.phone}'),
                ],
              )
            ],
          ),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        // Container(
        //   color: bgColor,
        //   padding: EdgeInsets.symmetric(
        //     horizontal: defaultPadding,
        //     vertical: defaultPadding / 2,
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text('Account Credits'),
        //       Text(
        //         '${Constants.RUPEE} 52.25',
        //         style: TextStyle(
        //           color: primaryColor,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        SizedBox(
          height: defaultPadding,
        ),
        ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed(UpdateProfileScreen.UPDATE_PROFILE_ROUTE)
                .then((value) {
              setState(() {
                user = UserModel.fromJson(prefs.getString(PrefernceKey.USER)!);
                log(user.toString());
              });
            });
          },
          tileColor: bgColor,
          title: Text(
            'Edit Profile',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
          ),
          subtitle: Text('Update your profile details'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(AllAddressScreen.ALL_ADDRESS_ROUTE),
          tileColor: bgColor,
          title: Text(
            'Address',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
          ),
          subtitle: Text('Add or remove a delivery address'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(ChangePasswordScreen.CHANGE_PASSWORD_ROUTE),
          tileColor: bgColor,
          title: Text(
            'Change Password',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 18),
          ),
          subtitle: Text('Reset current password'),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        // ListTile(
        //   tileColor: bgColor,
        //   title: Text(
        //     'Refer Friends',
        //     style:
        //         Theme.of(context).textTheme.headline6?.copyWith(fontSize: 20),
        //   ),
        //   subtitle: Text(
        //     'Get ${Constants.RUPEE}10.00 FREE',
        //     style: Theme.of(context).textTheme.subtitle2?.copyWith(
        //           color: primaryColor,
        //           fontWeight: FontWeight.bold,
        //         ),
        //   ),
        //   trailing: Icon(Icons.keyboard_arrow_right),
        // ),
        // Divider(
        //   color: borderColor,
        //   height: 1,
        // ),
        ListTile(
          onTap: () => Navigator.of(context).pushNamed(
              WebviewInternal.WEBVIEW_ROUTE,
              arguments: API.MUNCHBOX),
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/munch_box.png'),
          ),
          tileColor: bgColor,
          title: Text(
            'Munchbox',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(WebviewInternal.WEBVIEW_ROUTE, arguments: API.HOTCASE),
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/images/hotcase_1.png'),
          ),
          tileColor: bgColor,
          title: Text(
            'CJ\'s Hotcase',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pushNamed(FeedbackScreen.FEEDBACK_ROUTE),
          leading: CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(
              Icons.support_agent_outlined,
              color: bgColor,
            ),
          ),
          tileColor: bgColor,
          title: Text(
            'Report a problem',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          onTap: () {
            launch('https://www.combojumbo.in/support');
          },
          leading: CircleAvatar(
            backgroundColor: Colors.pink,
            child: Icon(
              Icons.call_outlined,
              color: bgColor,
            ),
          ),
          tileColor: bgColor,
          title: Text(
            'Contact Us',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          onTap: () =>
              Navigator.of(context).pushNamed(TermOfUseSceen.TERMS_ROUTE),
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(
              Icons.info_outline,
              color: bgColor,
            ),
          ),
          tileColor: bgColor,
          title: Text(
            'Terms of Service',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(PrivacyPolicyScreen.PRIVACY_ROUTE),
          leading: CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.lock_outline,
              color: bgColor,
            ),
          ),
          tileColor: bgColor,
          title: Text(
            'Privacy Policy',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
        Divider(
          color: borderColor,
          height: 1,
        ),
        ListTile(
          onTap: () {
            prefs.clear();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.LOGIN_ROUTE, (route) => false);
          },
          leading: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Icon(
              Icons.logout_outlined,
              color: bgColor,
            ),
          ),
          tileColor: bgColor,
          title: Text(
            'Logout',
            style:
                Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 18),
          ),
          minVerticalPadding: defaultPadding * 1.5,
        ),
      ],
    );
  }
}
