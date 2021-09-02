import 'package:cjspoton/screen/home/home_screen.dart';
import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/screen/login_email/login_email_screen.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/screen/otp_verification/otp_verification_screen.dart';
import 'package:cjspoton/screen/reset_password/reset_password_screen.dart';
import 'package:cjspoton/services/auth_service.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/notification_api.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/services/snackbar_service.dart';
import 'package:cjspoton/utils/navigator.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
late String? CURRENT_USER = null;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();
  CURRENT_USER = prefs.getString(PrefernceKey.USER);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationApi.showNotification(
      id: message.hashCode,
      body: message.notification!.body,
      title: message.notification!.title,
      payload: message.data.toString());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => AuthenticationService(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ProfileManagementService(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => CatalogService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FastCheque',
        theme: globalTheme(context),
        onGenerateRoute: NavRoute.generatedRoute,
        home: (CURRENT_USER == null) ? LoginScreen() : MainContainer(),
      ),
    );
  }
}
