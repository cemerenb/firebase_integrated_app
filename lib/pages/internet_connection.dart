import 'package:flutter/material.dart';
import 'package:pirim_depo/utils/text.dart';

class InternetConnectionPage extends StatelessWidget {
  const InternetConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedCrossFade(
              firstChild: Text(
                connectionRetrying,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              secondChild: Text(
                noInternet,
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
              crossFadeState: CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 10),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(closeApp),
            ),
          ],
        ),
      ),
    );
  }
}
