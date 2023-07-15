import 'package:firebase_integrated_app/pages/create_password_page.dart';
import 'package:flutter/material.dart';

import '../utils/navigation.dart';
import '../utils/validators.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _user = TextEditingController();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _idno = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final bool _uservalidate = false;
  final bool _emailvalidate = false;
  final bool _namevalidate = false;
  final bool _idnovalidate = false;

  @override
  void dispose() {
    _user.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hesabını oluştur',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Kayıt Ol',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: _user,
                        validator: (value) =>
                            Validators.usernameValidator(value),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            errorText: _uservalidate
                                ? "Kullanıcı adı boş olamaz"
                                : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 148, 146, 146))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            hintText: 'Kullanıcı Adı',
                            contentPadding: const EdgeInsets.all(20.0)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _name,
                        validator: (value) => Validators.nameValidator(value),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            errorText:
                                _namevalidate ? "Ad soyad boş olamaz" : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 148, 146, 146))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            hintText: 'Ad Soyad',
                            contentPadding: const EdgeInsets.all(20.0)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _email,
                        validator: (value) => Validators.emailValidator(value),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            errorText:
                                _emailvalidate ? "Email Can't Be Empty" : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 148, 146, 146))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            hintText: 'Email',
                            contentPadding: const EdgeInsets.all(20.0)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _idno,
                        validator: (value) => Validators.idNoValidator(value),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            errorText: _idnovalidate
                                ? "Tc kimlik no boş olamaz"
                                : null,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 148, 146, 146))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.black)),
                            hintText: 'Tc Kimlik No',
                            contentPadding: const EdgeInsets.all(20.0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                Navigation.addRoute(
                                    context,
                                    CreatePasswordPage(
                                      username: _user.text,
                                      email: _email.text,
                                      name: _name.text,
                                      idno: _idno.text,
                                    ));
                              }
                            },
                            color: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              'Şifre Oluştur',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ])),
          ),
        ));
  }
}
