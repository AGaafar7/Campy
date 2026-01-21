import 'package:flutter/material.dart';

abstract class StyleManager {
  static const textOnLight = Colors.black;
  static const textOnDark = Colors.white;
  static const textFaded = Color(0xFF9899A5);
  static const iconOnLight = Colors.black;
  static const iconOnDark = Colors.white;
  static const textHighLight = Colors.black;
}

abstract class _LightColors {}

abstract class _DarkColors {
  static const backgroundColor = Color(0xFF333333);
  static const scaffoldBackgroundColor = Color(0xFF333333);
}

//Reference to the application theme
abstract class AppTheme {
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  //Light theme and its settings
  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      //backgroundColor: _LightColors.backgroundColor,
      titleTextStyle: TextStyle(color: StyleManager.textOnLight),
      iconTheme: IconThemeData(color: StyleManager.iconOnLight),
    ),
    visualDensity: visualDensity,
    //backgroundColor: _LightColors.backgroundColor,
    //scaffoldBackgroundColor: _LightColors.scaffoldBackgroundColor,
    textTheme: const TextTheme().apply(bodyColor: StyleManager.textOnLight),
    iconTheme: const IconThemeData(color: StyleManager.iconOnLight),
  );

  //Dark theme and its settings
  static ThemeData dark() => ThemeData(
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: _DarkColors.backgroundColor,
      titleTextStyle: TextStyle(color: StyleManager.textOnDark),
      iconTheme: IconThemeData(color: StyleManager.iconOnDark),
    ),
    visualDensity: visualDensity,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      brightness: Brightness.dark,
      background: _DarkColors.backgroundColor,
    ),
    scaffoldBackgroundColor: _DarkColors.scaffoldBackgroundColor,
    textTheme: const TextTheme().apply(bodyColor: StyleManager.textOnDark),
    iconTheme: const IconThemeData(color: StyleManager.iconOnDark),
  );
}
//TODO: Add the light Theme