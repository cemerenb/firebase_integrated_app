import 'package:flutter/material.dart';
import '../utils/navigation.dart';
import 'login_page.dart';

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
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(
                height: 50,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Maecenas ultricies mi eget mauris. Sem et tortor consequat id porta. Pretium aenean pharetra magna ac placerat. Mauris vitae ultricies leo integer.'),
                ),
              ),
              const SizedBox(height: 50),
              MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () async {
                    Navigation.addRoute(context, const CreateAccountPage());
                  },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 80,
              ),
              const Text('Already have an account?'),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () async {
                    Navigation.addRoute(context, const LoginPage());
                  },
                  color: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Log In',
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
