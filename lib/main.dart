import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_integrated_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = const HomePage();

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
        backgroundColor: Colors.white,
        listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.white),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      themeMode: ThemeMode.system,
      theme: ThemeData.light().copyWith(
        hintColor: Colors.black,
        primaryColor: Colors.black,
        inputDecorationTheme:
            const InputDecorationTheme(suffixIconColor: Colors.black),
        backgroundColor: Colors.white,
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
      ),
      home: currentPage,
    );
  }
}
