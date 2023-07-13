import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integrated_app/utils/dialog.dart';
import 'package:flutter/material.dart';

import '../components/password_text_field_with_validation.dart';
import '../services/auth.dart';

class CreatePasswordPage extends StatefulWidget {
  final String username;
  final String email;

  const CreatePasswordPage(
      {super.key, required this.username, required this.email});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

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
            PasswordTextFieldWithValidation(
              key: textFieldKey,
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(errorMessage!),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () async {
                    final validated =
                        textFieldKey.currentState?.validate() ?? false;

                    if (validated) {
                      final password = textFieldKey.currentState?.getPassword();
                      try {
                        final response = await AuthService.createPerson(
                            widget.username, widget.email, password ?? '');

                        if (response == null) {
                          setState(() {
                            errorMessage =
                                'Bir hata oluştu lütfen sonra tekrar deneyin';
                          });
                        } else {
                          setState(() {
                            showMyDialog(context,
                                "Hesabınızı onaylamanız için onay maili yollandı\nLütfen gelen kutunuzu ve spamları kontrol edin ");
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
            )
          ],
        ),
      ),
    );
  }
}
