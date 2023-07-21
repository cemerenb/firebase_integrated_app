import 'package:flutter/material.dart';
import 'package:pirim_depo/utils/text.dart';
import '../utils/text_box.dart';

class AcceptTerm extends StatelessWidget {
  const AcceptTerm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          termText1,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextBox(text: termText2),
            TextBox(text: termText3),
            TextBox(text: termText4),
            TextBox(text: termText5),
            TextBox(text: termText6),
            TextBox(text: termText7),
            TextBox(text: termText8),
            TextBox(text: termText9),
            TextBox(text: termText10),
            TextBox(text: termText11),
            TextBox(text: termText12),
            TextBox(text: termText13),
            TextBox(text: termText14),
            TextBox(text: termText15),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(about)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
