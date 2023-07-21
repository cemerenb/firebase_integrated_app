import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pirim_depo/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'theme/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    // ignore: prefer_typing_uninitialized_variables
    return MaterialApp(
      title: "İlk uygulamam",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Colors.black,
        primaryColor: Colors.black,
        inputDecorationTheme:
            const InputDecorationTheme(suffixIconColor: Colors.black),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.black,
        ),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.white),
        listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
        fontFamily: 'Dancing',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontFamily: 'Poppins'),
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
      ),
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.white,
        hintColor: Colors.white,
        inputDecorationTheme:
            const InputDecorationTheme(suffixIconColor: Colors.white),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.white),
        listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: 'Poppins'),
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
      ),
      themeMode: themeManager.currentThemeMode == ThemeModeType.light
          ? ThemeMode.light
          : ThemeMode.dark,
      home: const LoginPage(),
    );
  }
}
