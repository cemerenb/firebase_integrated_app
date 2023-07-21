import 'package:flutter/material.dart';
import 'package:pirim_depo/utils/term_text.dart';

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
            textBox(termText2),
            textBox(termText3),
            textBox(termText4),
            textBox(termText5),
            textBox(termText6),
            textBox(termText7),
            textBox(termText8),
            textBox(termText9),
            textBox(termText10),
            textBox(termText11),
            textBox(termText12),
            textBox(termText13),
            textBox(termText14),
            textBox(termText15),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('2023 @cemerenb')],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding textBox(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.start,
      ),
    );
  }
}
