import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pirim_depo/components/password_text_field_with_validation.dart';
import 'package:pirim_depo/pages/create_account_page.dart';
import 'package:pirim_depo/pages/starting_page.dart';
import 'package:pirim_depo/utils/dialog.dart';
import 'package:pirim_depo/utils/get_data_firestore.dart';
import 'package:pirim_depo/utils/navigation.dart';

class LoginPage extends StatefulWidget {
  final bool showLeading;

  const LoginPage({Key? key, this.showLeading = true}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<PasswordTextFieldWithValidationState> textFieldKey =
      GlobalKey<PasswordTextFieldWithValidationState>();
  final bool _validate = false;
  var user = FirebaseAuth.instance.currentUser;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? errorMessage;
  bool _isVisible = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    if (user == null) {
      log('User does not exist');
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigation.addRoute(
          context,
          StartPage(
            email: user!.email.toString(),
            isAdmin: getAdminStatus(user!.uid),
          ),
        );
      });
      log(user!.email.toString());
    }
    super.initState();
  }

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
            const Text(
              'Giriş yap',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Devam etmek için giriş yapın'),
            const SizedBox(height: 30),
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
                      color: Color.fromARGB(255, 148, 146, 146)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                hintText: 'Şifre',
                contentPadding: const EdgeInsets.all(20.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () async {
                    signIn(
                      emailController.text,
                      passwordController.text,
                      context,
                    );
                  },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _usernameTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: textInputDecoration(),
    );
  }

  TextField textInputDecoration() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorText: _validate ? "Email boş olamaz" : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 148, 146, 146),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        hintText: 'Email',
        contentPadding: const EdgeInsets.all(20.0),
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

      int a = await getLogedInStatus(user!.uid);
      log(a.toString());
      log("isVerified ${user.emailVerified}");
      if (user.emailVerified == true && mounted && a == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            FirebaseFirestore.instance
                .collection('person')
                .doc(user.uid)
                .update({'isLogedIn': a + 1});

            bool isAdmin =
                getAdminStatus(FirebaseAuth.instance.currentUser!.uid);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StartPage(
                  email: email,
                  isAdmin: isAdmin,
                ),
              ),
            );
            // ignore: empty_catches
          } catch (e) {}
        });
      } else if (user.emailVerified == false) {
        errorMessage =
            "Hesabınızı onaylamanız için onay maili yollandı\nLütfen gelen kutunuzu ve spamları kontrol edin ";

        setState(() {});
        showMyDialog(context, errorMessage.toString());
        user.sendEmailVerification();
        FirebaseAuth.instance.signOut();
      } else if (a != 0) {
        errorMessage = "Hesabınız başka bir cihazda açık\nLütfen çıkış yapın";
        setState(() {});
        showMyDialog(context, errorMessage.toString());
        FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        log(e.toString());
        errorMessage = e.toString();
        showMyDialog(context, errorMessage.toString());
        setState(() {});
      });
    }
  }
}
