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
          children: const [],
        ),
      ),
    );
  }
}
