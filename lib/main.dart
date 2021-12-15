import 'dart:developer';

import 'package:cjspoton/screen/choose_outlet/choose_outlet_screen.dart';
import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/screen/main_container/main_container.dart';
import 'package:cjspoton/services/address_service.dart';
import 'package:cjspoton/services/auth_service.dart';
import 'package:cjspoton/services/cart_services.dart';
import 'package:cjspoton/services/catalog_service.dart';
import 'package:cjspoton/services/profile_management_service.dart';
import 'package:cjspoton/utils/navigator.dart';
import 'package:cjspoton/utils/prefs_key.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:cjspoton/utils/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
// late String? CURRENT_USER = null;
late bool? isLoggedIn = null;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();
  // CURRENT_USER = prefs.getString(PrefernceKey.USER);
  isLoggedIn = prefs.getBool(PrefernceKey.IS_LOGGEDIN);
  runApp(MyApp());
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
        ChangeNotifierProvider(
          create: (BuildContext context) => CartServices(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => AddressService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FastCheque',
        theme: globalTheme(context),
        onGenerateRoute: NavRoute.generatedRoute,
        home: (isLoggedIn == null)
            ? LoginScreen()
            : prefs.getString(PrefernceKey.SELECTED_OUTLET) == null
                ? ChooseOutletScreen()
                : MainContainer(
                    initialIndex: 0,
                  ),
      ),
    );
  }
}
