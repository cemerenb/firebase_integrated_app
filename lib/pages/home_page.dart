import 'package:firebase_integrated_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../utils/navigation.dart';

import 'create_account_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Image.asset(
                'assets/img/pirim.png',
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
              ),
              const SizedBox(height: 50),
              MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () async {
                    Navigation.addRoute(context, const CreateAccountPage());
                  },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Kayıt ol',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 80,
              ),
              const Spacer(),
              const Text('Zaten hesabınız var mı?'),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () async {
                    Navigation.addRoute(context, const LoginPage());
                  },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Giriş yap',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ));
  }
}
