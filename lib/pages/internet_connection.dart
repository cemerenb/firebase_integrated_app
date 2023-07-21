import 'package:flutter/material.dart';

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
            const AnimatedCrossFade(
              firstChild: Text(
                'Retrying to connect...',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              secondChild: Text(
                'No internet connection!',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              crossFadeState: CrossFadeState.showSecond,
              duration: Duration(milliseconds: 10),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close App'),
            ),
          ],
        ),
      ),
    );
  }
}
