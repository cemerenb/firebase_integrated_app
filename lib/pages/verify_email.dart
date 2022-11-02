import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integrated_app/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../utils/navigation.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final auth = FirebaseAuth.instance;

  User? user;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    user?.sendEmailVerification();

    Future.delayed(const Duration(seconds: 3), (() {
      Navigation.addRoute(
          context,
          const LoginPage(
            showLeading: false,
          ));
    }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text('An email has been sent to ${user?.email} please check your mailbox and your spam folder'),
          ),
        ],
      ),
    );
  }
}
