import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class HasInternet extends ChangeNotifier {
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  Future<bool> checkInternetConnection() async {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      _isOnline = connectivityResult != ConnectivityResult.none;
      notifyListeners();
    });

    return _isOnline;
  }
}
