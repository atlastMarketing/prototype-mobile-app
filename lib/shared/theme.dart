import 'package:flutter/material.dart';

class AppColors {
  static const Map<int, Color> _primaryColorSwatch = {
    50: Color.fromRGBO(94, 80, 234, .1),
    100: Color.fromRGBO(94, 80, 234, .2),
    200: Color.fromRGBO(94, 80, 234, .3),
    300: Color.fromRGBO(94, 80, 234, .4),
    400: Color.fromRGBO(94, 80, 234, .5),
    500: Color.fromRGBO(94, 80, 234, .6),
    600: Color.fromRGBO(94, 80, 234, .7),
    700: Color.fromRGBO(94, 80, 234, .8),
    800: Color.fromRGBO(94, 80, 234, .9),
    900: Color.fromRGBO(94, 80, 234, 1),
  };
  static const primary = MaterialColor(0xFF5E50EA, _primaryColorSwatch);

  static const Map<int, Color> _accentColorSwatch = {
    50: Color.fromRGBO(121, 139, 253, .1),
    100: Color.fromRGBO(121, 139, 253, .2),
    200: Color.fromRGBO(121, 139, 253, .3),
    300: Color.fromRGBO(121, 139, 253, .4),
    400: Color.fromRGBO(121, 139, 253, .5),
    500: Color.fromRGBO(121, 139, 253, .6),
    600: Color.fromRGBO(121, 139, 253, .7),
    700: Color.fromRGBO(121, 139, 253, .8),
    800: Color.fromRGBO(121, 139, 253, .9),
    900: Color.fromRGBO(121, 139, 253, 1),
  };
  static const accent = MaterialColor(0xFF798BFD, _accentColorSwatch);

  static const confirm = Color.fromRGBO(253, 150, 130, 1.0);
  static const customize = Color.fromRGBO(214, 192, 244, 1.0);
  static const cancel = Color.fromRGBO(154, 205, 214, 1.0);

  static const black = Colors.black;
  static const light = Colors.grey;
  static const white = Colors.white;
}

class AppText {
  static const heading = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  static const subheading =
      TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  static const title = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const subtitle =
      TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  static const body = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
  static const bodySmall =
      TextStyle(fontSize: 12, fontWeight: FontWeight.normal);

  static const blackText = TextStyle(color: AppColors.black);
  static const whiteText = TextStyle(color: AppColors.black);
}
