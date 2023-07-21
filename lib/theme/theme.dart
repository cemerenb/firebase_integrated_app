import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme = ThemeData().copyWith(
  hintColor: Colors.black,
  primaryColor: Colors.black,
  inputDecorationTheme:
      const InputDecorationTheme(suffixIconColor: Colors.black),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.black,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
  listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark),
    titleTextStyle:
        TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Poppins'),
    centerTitle: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  colorScheme: const ColorScheme(
      background: Colors.white,
      brightness: Brightness.light,
      error: Colors.black,
      onBackground: Colors.black,
      onError: Colors.black,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      primary: Color.fromARGB(255, 82, 82, 82),
      secondary: Color.fromARGB(255, 255, 255, 255),
      surface: Color.fromARGB(255, 255, 255, 255)),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
    ),
  ),
  primaryColor: Colors.white,
  hintColor: Colors.white,
  inputDecorationTheme:
      const InputDecorationTheme(suffixIconColor: Colors.white),
  buttonTheme: const ButtonThemeData(buttonColor: Colors.white),
  listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white),
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light),
    titleTextStyle:
        TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
    centerTitle: true,
    color: Colors.transparent,
    elevation: 0,
  ),
  colorScheme: const ColorScheme(
      background: Color.fromARGB(255, 255, 255, 255),
      brightness: Brightness.dark,
      error: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      onPrimary: Color.fromARGB(255, 255, 255, 255),
      onSecondary: Colors.white,
      onSurface: Colors.white,
      primary: Color.fromARGB(255, 212, 212, 212),
      secondary: Colors.white,
      surface: Colors.white),
);
