// ignore: unused_import
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/navigation.dart';
import 'home_page.dart';

class WelcomePage extends StatelessWidget {
  final String email;

  WelcomePage({super.key, required this.email});
  final auth = FirebaseAuth.instance;
  final bool isverify = false;
  User? user;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Hoş Geldin',
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(
              height: 100,
            ),
            Text(
              email,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: MaterialButton(
                minWidth: double.infinity,
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigation.navigateRoute(context, const HomePage());
                },
                color: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
