import 'dart:developer';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future scanBarcode() async {
  log('barcoda girdi');
  String scanResult;
  try {
    scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'İptal', true, ScanMode.BARCODE);
  } catch (e) {
    scanResult = "Bir hata oluştu!";
  }

  return scanResult = scanResult;
}

Future scanQR() async {
  log('barcoda girdi');
  String scanResult;
  try {
    scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'İptal', true, ScanMode.QR);
  } catch (e) {
    scanResult = "Bir hata oluştu!";
  }

  return scanResult = scanResult;
}
