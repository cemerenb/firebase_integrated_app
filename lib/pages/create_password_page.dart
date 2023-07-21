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
  final bool isOwner = false;

  const CreatePasswordPage({
    Key? key,
    required this.username,
    required this.email,
    required this.name,
    required this.idno,
  }) : super(key: key);

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final textFieldKey = GlobalKey<PasswordTextFieldWithValidationState>();
  String? errorMessage;
  late String profilUrl = '';

  bool isChecked = false;

  void toggleCheckBox() {
    setState(() {
      isChecked = !isChecked;
      log(isChecked.toString());
    });
  }

  Future<void> createAccount() async {
    final validated = textFieldKey.currentState?.validate() ?? false;

    if (validated && !isChecked) {
      final password = textFieldKey.currentState?.getPassword();

      try {
        log(widget.isOwner.toString());

        final response = await AuthService.createPerson(
            widget.username,
            widget.email,
            password ?? '',
            widget.isAdmin,
            widget.name,
            widget.idno,
            widget.isOwner,
            isLogedIn,
            profilUrl);

        log('person created');

        final usercred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email.trim(),
          password: password ?? '',
        );

        log('Verification mail sent');

        final user = usercred.user;
        user?.sendEmailVerification();
        FirebaseAuth.instance.signOut();

        if (response == null && mounted) {
          errorMessage = 'Bir hata oluştu. Lütfen daha sonra tekrar deneyin';
          showMyDialog(context, errorMessage.toString());
          log(errorMessage.toString());
        } else {
          showMyDialog(
            context,
            'Hesabınızı onaylamanız için onay maili gönderildi.\nLütfen gelen kutunuzu ve spam klasörünü kontrol edin',
          );
          Navigation.addRoute(context, const LoginPage());
          return;
        }
      } on FirebaseAuthException {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Hesabını oluştur',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Şifre oluştur',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
                'Lütfen aşağıdaki kriterleri karşılayan bir şifre oluşturun'),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: PasswordTextFieldWithValidation(
                key: textFieldKey,
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 30),
              Text(errorMessage!),
            ],
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: toggleCheckBox,
                    child: isChecked
                        ? const Icon(Icons.check_box_outline_blank)
                        : const Icon(Icons.check_box_outlined),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigation.addRoute(context, const AcceptTerm());
                    },
                    child: const Text('Sorumluluk metnini'),
                  ),
                  const Text('okudum onaylıyorum.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: createAccount,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
