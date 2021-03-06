import 'package:flutter/material.dart';

// const primaryColor = Color(0xffffad00);
MaterialColor primaryColor = MaterialColor(0xffff9000, color);
const secondaryColor = Color(0xFFFFFFFF);
const bgColor = Color(0xFFFFFFFF);

const hintColor = Color(0xFFADADAD);
const textColor = Color(0xFF2A2D3E);
const fillColor = Color(0xFFF5F5F5);
const borderColor = Color(0xFF878787);
const greyedBgColor = Color(0xFFF7F7F7);
const categoryBackground = Color(0xFF0b1425);

Map<int, Color> color = {
  50: Color.fromRGBO(255, 144, 0, .1),
  100: Color.fromRGBO(255, 144, 0, .2),
  200: Color.fromRGBO(255, 144, 0, .3),
  300: Color.fromRGBO(255, 144, 0, .4),
  400: Color.fromRGBO(255, 144, 0, .5),
  500: Color.fromRGBO(255, 144, 0, .6),
  600: Color.fromRGBO(255, 144, 0, .7),
  700: Color.fromRGBO(255, 144, 0, .8),
  800: Color.fromRGBO(255, 144, 0, .9),
  900: Color.fromRGBO(255, 144, 0, 1),
};

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

// Svg colors replace
// E23744
// FFC108
