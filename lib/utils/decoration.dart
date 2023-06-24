import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'dart:math' as math;

class MainPageBoxStyle {
  Random random = Random();
  var options = Options(format: Format.hex, colorType: ColorType.green);
  Container boxDecoration(BuildContext context, String data) {
    return Container(
        // ignore: sort_child_properties_last
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            data,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
          ),
        ),
        alignment: Alignment.topCenter,
        height: random.nextInt(90) + 170,
        width: MediaQuery.of(context).size.width/2-20,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(0.7),
                  Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(0.4)
                ]),
            borderRadius: BorderRadius.circular(20)));
  }
}
