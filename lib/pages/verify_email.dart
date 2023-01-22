import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integrated_app/pages/home_page.dart';
import 'package:firebase_integrated_app/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../utils/navigation.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
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

  Future sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 60));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      setState(() {
        SnackBar(content: Text(e.toString()));
      });
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const HomePage()
      : Scaffold(
          appBar: AppBar(
              title: Text(
            'Verify Your Account',
            style: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          )),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'We have sent an email for account verification to ${user?.email} Please check your mailbox and your spam folder.',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold)),
                MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    canResendEmail
                        ? sendEmailVerification()
                        : const Text('Please wait to send again');
                  },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Creat Account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
}
