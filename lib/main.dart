import 'package:cjspoton/screen/login/login_screen.dart';
import 'package:cjspoton/utils/navigator.dart';
import 'package:cjspoton/utils/theme_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FastCheque',
      theme: globalTheme(context),
      onGenerateRoute: NavRoute.generatedRoute,
      home: LoginScreen(),
    );
  }
}
