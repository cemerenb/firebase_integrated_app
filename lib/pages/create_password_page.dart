import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pirim_depo/pages/accept_term.dart';
import 'package:pirim_depo/pages/login_page.dart';
import 'package:pirim_depo/utils/dialog.dart';
import 'package:pirim_depo/utils/get_data_firestore.dart';
import 'package:pirim_depo/utils/navigation.dart';
import 'package:flutter/material.dart';

import '../components/password_text_field_with_validation.dart';
import '../services/auth.dart';

class CreatePasswordPage extends StatefulWidget {
  final String username;
  final String email;
  final String name;
  final String idno;
  final bool isAdmin = false;
  final bool isChecked = false;
  final bool isOwner = false;

  const CreatePasswordPage(
      {super.key,
      required this.username,
      required this.email,
      required this.name,
      required this.idno});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

String name = '';

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  GlobalKey<PasswordTextFieldWithValidationState> textFieldKey =
      GlobalKey<PasswordTextFieldWithValidationState>();
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Hesabını oluştur',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Şifre oluştur',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            const Text(
                'Lütfen aşağıdaki kriterleri karşılıyan bir şifre oluşturun'),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: PasswordTextFieldWithValidation(
                key: textFieldKey,
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(errorMessage!),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        isChecked = !isChecked;
                        setState(() {
                          log(isChecked.toString());
                        });
                      },
                      child: isChecked
                          ? const Icon(Icons.check_box_outline_blank)
                          : const Icon(Icons.check_box_outlined)),
                  TextButton(
                      onPressed: () {
                        Navigation.addRoute(context, const AcceptTerm());
                      },
                      child: const Text('Sorumluluk metnini')),
                  const Text("okudum onaylıyorum."),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () async {
                    final validated =
                        textFieldKey.currentState?.validate() ?? false;

                    if (validated && isChecked == false) {
                      final password = textFieldKey.currentState?.getPassword();
                      try {
                        log(isOwner.toString());
                        final response = await AuthService.createPerson(
                            widget.username,
                            widget.email,
                            password ?? '',
                            widget.isAdmin,
                            widget.name,
                            widget.idno,
                            isOwner);
                        log('person created');
                        final usercred = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: widget.email.trim(),
                          password: password ?? '',
                        );
                        log('Verification mail send');
                        final user = usercred.user;
                        user?.sendEmailVerification();
                        FirebaseAuth.instance.signOut();

                        if (response == null) {
                          errorMessage =
                              'Bir hata oluştu lütfen sonra tekrar deneyin';
                          setState(() {
                            showMyDialog(context, errorMessage.toString());
                          });
                          log(errorMessage.toString());
                        } else {
                          setState(() {
                            showMyDialog(context,
                                "Hesabınızı onaylamanız için onay maili yollandı\nLütfen gelen kutunuzu ve spamları kontrol edin ");
                            Navigation.addRoute(context, const LoginPage());
                          });

                          return;
                        }
                      } on FirebaseAuthException {
                        setState(() {});
                      }
                    }
                  },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Hesap oluştur',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
