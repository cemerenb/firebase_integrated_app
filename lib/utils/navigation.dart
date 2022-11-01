import 'package:flutter/material.dart';

class Navigation {
  static MaterialPageRoute route(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  static void addRoute(BuildContext context, Widget page) {
    final route = Navigation.route(page);
    Navigator.push(context, route);
  }

  static void navigateRoute(BuildContext context, Widget page) {
    final route = Navigation.route(page);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  static void popRoute(BuildContext context) {
    Navigator.pop(context);
  }
}
