import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pirim_depo/theme/theme.dart';

enum ThemeModeType {
  light,
  dark,
}

class ThemeManager with ChangeNotifier {
  ThemeModeType _currentThemeMode = ThemeModeType.dark;

  ThemeModeType get currentThemeMode => _currentThemeMode;

  void toggleTheme() {
    _currentThemeMode = _currentThemeMode == ThemeModeType.light
        ? ThemeModeType.dark
        : ThemeModeType.light;

    final themeMode = _currentThemeMode == ThemeModeType.dark
        ? ThemeMode.dark
        : ThemeMode.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
    ));

    notifyListeners();
  }

  ThemeData getThemeData() {
    return _currentThemeMode == ThemeModeType.light ? lightTheme : darkTheme;
  }
}
