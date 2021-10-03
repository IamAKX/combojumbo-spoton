import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/utils/colors.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IOSLoginNeeded extends StatefulWidget {
  const IOSLoginNeeded({Key? key}) : super(key: key);
  static const String IOS_LOGIN_NEEDED_ROUTE = '/iosLoginNeeded';
  @override
  _IOSLoginNeededState createState() => _IOSLoginNeededState();
}

class _IOSLoginNeededState extends State<IOSLoginNeeded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
        ),
        backgroundColor: bgColor,
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svg/login_needed.svg',
                  width: 300,
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Text(
                  'You need to login to access this area!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(fontSize: 20),
                ),
                SizedBox(
                  height: defaultPadding * 4,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                            LoginScreen.LOGIN_ROUTE, (route) => false),
                    child: Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
