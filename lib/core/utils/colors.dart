import 'package:flutter/material.dart';

/// All name colors according to https://chir.ag/projects/name-that-color
class AppColors {
  const AppColors();

  static const _white = Colors.white;
  static const _alabaster = Color(0xffF8F8F8);
  static const _darkBlue = Color(0xff2308B9);
  static const _pacificBlue = Color(0xff07A6B9);
  static const _silverSand = Color(0xffC3C6C9);
  static const _mineShaft = Color(0xff262626);
  static const _bastille = Color(0xff201A25);
  static const _alto = Color(0xffD9D9D9);
  static const _royalBlue = Color(0xff6F5BE2);
  static const _silver = Color(0xffC8C8C8);
  static const _dustyGray = Color(0xff9A9A9A);
  static const _iceberg = Color(0xffDAF2F5);
  static const _athensGray = Color(0xffEEF1F4);
  //dark
  static const _shark = Color(0xff1D1D1F);
  static const _tuna = Color(0xff313133);
  static const _stormGray = Color(0xff7A7D8A);
  static const _mountainMist = Color(0xff8C8A93);

  /// text colors
  static const titleLarge = _darkBlue;
  static const titleMedium = _darkBlue;
  static const titleSmall = _darkBlue;
  static const bodySmall = _silverSand;
  static const bodyMedium = _darkBlue;
  static const labelSmall = _mineShaft;
  static const labelMedium = _bastille;

  static const darkTitleLarge = Colors.white;
  static const darkTitleMedium = Colors.white;
  static const darkTitleSmall = Colors.white;
  static const darkBodyMedium = Colors.white;
  static const darkLabelSmall = Colors.white;

  /// material color
  static MaterialColor getLightMaterialColor() {
    return MaterialColor(const Color(0xff2308B9).value, const <int, Color>{
      50: _darkBlue,
      100: _darkBlue,
      200: _darkBlue,
      300: _darkBlue,
      400: _darkBlue,
      500: _darkBlue,
      600: _darkBlue,
      700: _darkBlue,
      800: _darkBlue,
      900: _darkBlue,
    });
  }

  /// light app theme ...
  static const colorSchemeSeed = _white;
  static const lightPrimaryColor = _darkBlue;
  static const lightSecondaryColor = _pacificBlue;
  static const lightScaffoldBackground = _alabaster;
  static const lightStatusBar = _white;
  static const lightAppBarBackground = _alabaster;
  static const lightAppBarIcon = _darkBlue;
  static const lightIconTheme = _darkBlue;
  static const lightAppBarTextColor = _darkBlue;
  static const tabBarIndicator = _iceberg;
  static const lightCardColor = Colors.white;
  static const lightIconBackGround=_athensGray;

  /// login screen
  static const elevatedButtonSecondColor = _alto;
  static const loginSubtitle = _royalBlue;
  static const hintTextColor = _silver;
  static const textFieldIconColor = _dustyGray;

  /// dark app theme
  static const darkScaffoldBackGround = _shark;
  static const darkAppBarBackGround = _shark;
  static const darkTabIndicator = lightSecondaryColor;
  static const darkSecondaryColor = _stormGray;
  static const darkCardColor = _tuna;
  static const darkFileColor = _mountainMist;
  static const darkIconBackGround=_mountainMist;
}
