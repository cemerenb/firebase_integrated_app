// ignore: unused_import
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integrated_app/pages/login_page.dart';
import 'package:firebase_integrated_app/services/auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  final bool isverify = false;
  User? user;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Text("Profile Page"),
            IconButton(
              icon: const Icon(
                Icons.logout,
                size: 50,
              ),
              onPressed: () async {
                AuthService.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => const LoginPage()),
                    (route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}
