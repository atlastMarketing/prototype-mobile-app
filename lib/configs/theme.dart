import 'package:flutter/material.dart';

class AppColors {
  static const Map<int, Color> _primaryColorSwatch = {
    50: Color.fromRGBO(105, 92, 235, .1),
    100: Color.fromRGBO(105, 92, 235, .2),
    200: Color.fromRGBO(105, 92, 235, .3),
    300: Color.fromRGBO(105, 92, 235, .4),
    400: Color.fromRGBO(105, 92, 235, .5),
    500: Color.fromRGBO(105, 92, 235, .6),
    600: Color.fromRGBO(105, 92, 235, .7),
    700: Color.fromRGBO(105, 92, 235, .8),
    800: Color.fromRGBO(105, 92, 235, .9),
    900: Color.fromRGBO(105, 92, 235, 1),
  };
  static const primary = MaterialColor(0xFF695CEB, _primaryColorSwatch);

  static const Map<int, Color> _secondaryColorSwatch = {
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
  static const secondary = MaterialColor(0xFF798BFD, _secondaryColorSwatch);

  static const Map<int, Color> _accentColorSwatch = {
    50: Color.fromRGBO(84, 107, 232, .1),
    100: Color.fromRGBO(84, 107, 232, .2),
    200: Color.fromRGBO(84, 107, 232, .3),
    300: Color.fromRGBO(84, 107, 232, .4),
    400: Color.fromRGBO(84, 107, 232, .5),
    500: Color.fromRGBO(84, 107, 232, .6),
    600: Color.fromRGBO(84, 107, 232, .7),
    700: Color.fromRGBO(84, 107, 232, .8),
    800: Color.fromRGBO(84, 107, 232, .9),
    900: Color.fromRGBO(84, 107, 232, 1),
  };
  static const accent = MaterialColor(0xFF546BE8, _accentColorSwatch);

  static const confirm = Color.fromRGBO(154, 205, 214, 1.0);
  static const customize = Color.fromRGBO(214, 192, 244, 1.0);
  static const error = Color.fromRGBO(253, 150, 130, 1.0);

  static const black = Colors.black;
  static const dark = Colors.grey;
  static const light = Color.fromRGBO(241, 241, 253, 1.0);
  static const background = Color.fromRGBO(250, 250, 250, 1.0);
  static const white = Colors.white;
}

class AppText {
  // title
  static const title = TextStyle(
    // fontFamily: 'Grancino',
    fontSize: 60,
    fontWeight: FontWeight.w700,
  );
  // heading
  static const heading = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );
  static const subheading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
  );
  // buttons
  static const buttonLargeText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static const buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  // body
  static const bodyLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
  );
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  static const bodyBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static const bodySemiBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const bodyItalic = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );
  static const bodySmall = TextStyle(
    fontSize: 12,
  );

  static const primaryText = TextStyle(color: AppColors.primary);
  static const darkText = TextStyle(color: AppColors.dark);
  static const blackText = TextStyle(color: AppColors.black);
  static const whiteText = TextStyle(color: AppColors.white);
  static const errorText = TextStyle(fontSize: 12, color: AppColors.error);
}
