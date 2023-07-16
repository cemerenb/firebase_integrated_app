import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pirim_depo/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = const LoginPage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "İlk uygulamam",
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        hintColor: Colors.white,
        inputDecorationTheme:
            const InputDecorationTheme(suffixIconColor: Colors.white),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.white),
        listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
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
      themeMode: ThemeMode.system,
      theme: ThemeData.light().copyWith(
        hintColor: Colors.black,
        primaryColor: Colors.black,
        inputDecorationTheme:
            const InputDecorationTheme(suffixIconColor: Colors.black),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.black),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.white),
        listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
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
            secondary: Colors.black,
            surface: Colors.black),
      ),
      home: currentPage,
    );
  }
}
