import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integrated_app/pages/profile_page.dart';
import 'package:flutter/material.dart';
import '../utils/navigation.dart';
import 'package:firebase_integrated_app/utils/decoration.dart';
import 'package:firebase_integrated_app/utils/data.dart';

// ignore: must_be_immutable
class WelcomePage extends StatelessWidget {
  final String email;

  WelcomePage({super.key, required this.email});
  final auth = FirebaseAuth.instance;
  final bool isverify = false;
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            title: Text(
              "Notes",
              style: Theme.of(context).textTheme.headline5,
            ),
            actions: [
              MaterialButton(
                  onPressed: () => Navigation.addRoute(context, ProfilePage()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: Image.network(
                          'https://avatars.githubusercontent.com/u/82811515?v=4'),
                    ),
                  ))
            ],
          )
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 161, 161, 161),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 100,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: MainPageBoxStyle()
                            .boxDecoration(context, texts().data),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: MainPageBoxStyle()
                            .boxDecoration(context, texts().data),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: MainPageBoxStyle()
                            .boxDecoration(context, texts().data),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: MainPageBoxStyle()
                            .boxDecoration(context, texts().data),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: MainPageBoxStyle()
                            .boxDecoration(context, texts().data),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: MainPageBoxStyle()
                              .boxDecoration(context, texts().data),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: MainPageBoxStyle()
                              .boxDecoration(context, texts().data),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: MainPageBoxStyle()
                              .boxDecoration(context, texts().data),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: MainPageBoxStyle()
                              .boxDecoration(context, texts().data),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: MainPageBoxStyle()
                              .boxDecoration(context, texts().data),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: MainPageBoxStyle()
                              .boxDecoration(context, texts().data),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
