import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integrated_app/pages/create_account_page.dart';
import 'package:firebase_integrated_app/pages/starting_page.dart';
import 'package:flutter/material.dart';
import '../utils/dialog.dart';
import '../utils/is_admin.dart';
import '../utils/navigation.dart';
import '../components/password_text_field_with_validation.dart';

// ignore: camel_case_types
class LoginPage extends StatefulWidget {
  final bool showLeading;
  const LoginPage({super.key, this.showLeading = true});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// ignore: camel_case_types
class _LoginPageState extends State<LoginPage> {
  GlobalKey<PasswordTextFieldWithValidationState> textFieldKey =
      GlobalKey<PasswordTextFieldWithValidationState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bool _validate = false;
  String? errorMessage;
  bool _isVisible = false;
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: widget.showLeading,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Giriş yap',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            const Text('Devam etmek için giriş yapın'),
            const SizedBox(
              height: 30,
            ),
            _usernameTextField(),
            TextField(
              keyboardType: TextInputType.text,
              controller: passwordController,
              obscureText: !_isVisible,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    icon: _isVisible
                        ? const Icon(
                            Icons.visibility,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: Color.fromARGB(255, 146, 146, 146),
                          ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 148, 146, 146))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black)),
                  hintText: 'Şifre',
                  contentPadding: const EdgeInsets.all(20.0)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () async {
                    signIn(
                        emailController.text, passwordController.text, context);
                  },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Giriş yap',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Hesabınız yok mu?",
                    style: TextStyle(fontSize: 17),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigation.addRoute(context, const CreateAccountPage());
                      },
                      child: const Text(
                        'Kayıt ol',
                        style: TextStyle(fontSize: 17),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _usernameTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            errorText: _validate ? "Email boş olamaz" : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 148, 146, 146))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black)),
            hintText: 'Email',
            contentPadding: const EdgeInsets.all(20.0)),
      ),
    );
  }

  Future signIn(String email, String password, BuildContext context) async {
    try {
      final usercred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = usercred.user;
      if (user?.emailVerified == true && mounted) {
        // ignore: use_build_context_synchronously
        try {
          bool isAdmin = getAdminStatus(FirebaseAuth.instance.currentUser!.uid);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StartPage(
                      email: email,
                      isAdmin: isAdmin,
                    )),
          );
        } catch (e) {}
      } else {
        errorMessage =
            "Hesabınızı onaylamanız için onay maili yollandı\nLütfen gelen kutunuzu ve spamları kontrol edin ";

        setState(() {});
        showMyDialog(context, errorMessage.toString());
        user?.sendEmailVerification();
        FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        log(e.toString());
        errorMessage = e.toString();
        showMyDialog(context, errorMessage.toString());
        setState(() {});
      });

      // Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      //ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    // ignore: use_build_context_synchronously
  }
}
