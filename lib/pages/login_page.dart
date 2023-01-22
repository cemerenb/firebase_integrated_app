import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/navigation.dart';
import 'welcome_page.dart';
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
  Future<bool> _onWillPop() async {
    return false;
  }

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: widget.showLeading,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Log In',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              const Text('Please sign in to continue'),
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
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.all(20.0)),
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
                      signIn(emailController.text, passwordController.text,
                          context);
                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
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
            errorText: _validate ? "Email Can't Be Empty" : null,
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
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => const Center(
              child: CircularProgressIndicator(),
            )));

    try {
      final usercred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = usercred.user;
      if (user?.emailVerified == true) {
        // ignore: use_build_context_synchronously
        return Navigation.addRoute(
            context,
            WelcomePage(
              email: email,
            ));
      } else {
        errorMessage =
            "Please verify your email\nAn email sent to your mailbox";
        setState(() {});
        user?.sendEmailVerification();
        FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
            errorMessage = e.toString();
          }));

      // Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      //ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    // ignore: use_build_context_synchronously
    Navigation.popRoute(context);
  }
}
