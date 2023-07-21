import 'dart:developer';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pirim_depo/utils/text.dart';

scanBarcode() async {
  log('barcoda girdi');
  String scanResult;
  try {
    scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', cancel, true, ScanMode.BARCODE);
  } catch (e) {
    scanResult = "Bir hata oluştu!";
  }

  return scanResult = scanResult;
}

scanQR() async {
  log('qr girdi');
  String scanResult;
  try {
    scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', cancel, true, ScanMode.QR);
  } catch (e) {
    scanResult = "Bir hata oluştu!";
  }
  log(scanResult);
  return scanResult = scanResult;
}
