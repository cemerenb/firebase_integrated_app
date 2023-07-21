import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pirim_depo/pages/create_password_page.dart';
import 'package:flutter/material.dart';
import '../utils/text_fields.dart';
import '../utils/navigation.dart';
import '../utils/text.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _user = TextEditingController();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _idno = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorText = '';
  String errorText1 = '';

  @override
  void dispose() {
    _user.dispose();
    _email.dispose();
    _name.dispose();
    _idno.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          createAccountText,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  register,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                CreateAccountPageUsernameTextField(user: _user),
                const SizedBox(height: 20),
                CreateAccountNameTextField(name: _name),
                const SizedBox(height: 20),
                createAccountEmailTextField(),
                const SizedBox(height: 20),
                createAccountIdNoTextField(),
                createAccountNavigatorButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding createAccountNavigatorButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: MaterialButton(
          minWidth: double.infinity,
          onPressed: () {
            if (errorText == '' &&
                errorText1 == '' &&
                _email.text.isNotEmpty &&
                _idno.text.isNotEmpty) {
              if (formKey.currentState?.validate() ?? false) {
                Navigation.addRoute(
                  context,
                  CreatePasswordPage(
                    username: _user.text,
                    email: _email.text,
                    name: _name.text,
                    idno: _idno.text,
                  ),
                );
              }
            } else {
              log(errorText);
              setState(() {});
            }
          },
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            createPassword,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  TextFormField createAccountIdNoTextField() {
    return TextFormField(
      controller: _idno,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      onChanged: (value) async {
        errorText = await idNoValidator(_idno.text);
        log(errorText);
        setState(() {});
      },
      decoration: InputDecoration(
        errorText: errorText,
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
        hintText: idNo,
        contentPadding: const EdgeInsets.all(20.0),
      ),
    );
  }

  TextFormField createAccountEmailTextField() {
    return TextFormField(
      controller: _email,
      onChanged: (value) async {
        errorText1 = await emailValidator(_email.text);
        log(errorText1);
        setState(() {});
      },
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        errorText: errorText1,
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
        hintText: emailText,
        contentPadding: const EdgeInsets.all(20.0),
      ),
    );
  }
}

Future<String> idNoValidator(String idNo) async {
  String error = '';

  if (idNo.isEmpty || idNo.length != 11) {
    error = invalidIdNo;
    log(error);
    return error;
  }

  final personCollection = FirebaseFirestore.instance.collection('person');

  final snapshot = await personCollection.get();

  for (final doc in snapshot.docs) {
    final data = doc.data();
    if (data['idNo'] == idNo) {
      error = idNoIsUsing;
      log(error);
      return error;
    }
  }

  return '';
}

Future<String> emailValidator(String? mail) async {
  String mailErrorMessage = invalidEmail;

  if (mail == null || mail.isEmpty) {
    return mailErrorMessage;
  }

  if (!mail.contains('@')) {
    return mailErrorMessage;
  }

  final splittedMail = mail.split('@');

  if (splittedMail.length != 2 || !splittedMail[1].contains('.')) {
    return mailErrorMessage;
  }

  final personCollection = FirebaseFirestore.instance.collection('person');

  final snapshot = await personCollection.get();

  for (final doc in snapshot.docs) {
    final data = doc.data();
    if (data['email'] == mail) {
      mailErrorMessage = emailIsUsing;
      log(mailErrorMessage);
      return mailErrorMessage;
    }
  }

  return '';
}
