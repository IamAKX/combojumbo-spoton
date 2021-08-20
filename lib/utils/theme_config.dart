import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

const double defaultPadding = 16;

ThemeData globalTheme(BuildContext context) {
  return ThemeData(primarySwatch: Colors.amber).copyWith(
    scaffoldBackgroundColor: bgColor,
    backgroundColor: bgColor,
    primaryColor: primaryColor,
    accentColor: primaryColor,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(
            vertical: defaultPadding,
          ),
        ),
        overlayColor:
            MaterialStateColor.resolveWith((states) => primaryColor.shade300),
        backgroundColor: MaterialStateProperty.all(primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
            color: primaryColor,
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: defaultPadding),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: primaryColor,
      alignLabelWithHint: false,
      filled: true,
      fillColor: Colors.white,
      hoverColor: primaryColor,
      hintStyle: TextStyle(color: hintColor),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      Theme.of(context).textTheme,
    ).apply(
      bodyColor: textColor,
      displayColor: hintColor,
    ),
    canvasColor: secondaryColor,
  );
}

Theme getDatePickerTheme(Widget? child) {
  return Theme(
    data: ThemeData(
      primarySwatch: Colors.grey,
      splashColor: Colors.black,
      textTheme: TextTheme(
        subtitle1: TextStyle(color: Colors.black),
        button: TextStyle(color: Colors.black),
      ),
      accentColor: Colors.black,
      colorScheme: ColorScheme.light(
          primary: primaryColor,
          primaryVariant: Colors.black,
          secondaryVariant: Colors.black,
          onSecondary: Colors.black,
          onPrimary: Colors.white,
          surface: Colors.black,
          onSurface: Colors.black,
          secondary: Colors.black),
      dialogBackgroundColor: Colors.white,
    ),
    child: child ?? Text(""),
  );
}

class TransactionStatus {
  static const String SUBMITTED = 'SUBMITTED';
  static const String APPROVED = 'APPROVED';
  static const String REJECTED = 'REJECTED';
}
