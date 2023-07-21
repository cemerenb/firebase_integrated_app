import 'package:flutter/material.dart';
import 'package:pirim_depo/utils/text.dart';
import 'package:pirim_depo/utils/text_box.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(about),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                aboutText1,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextBox(text: aboutText2),
            TextBox(text: aboutText3),
            TextBox(text: aboutText4),
            TextBox(text: aboutText5),
            TextBox(text: aboutText6),
            TextBox(text: aboutText7),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(cem)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
