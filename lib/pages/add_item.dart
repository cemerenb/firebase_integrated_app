import 'dart:developer';
import 'package:firebase_integrated_app/utils/dialog.dart';
import 'package:firebase_integrated_app/utils/get_data_firestore.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../services/auth.dart';
import 'package:time_machine/time_machine.dart';

// ignore: must_be_immutable
class AddItem extends StatefulWidget {
  late String lastModifiedUser;

  AddItem({super.key, required this.lastModifiedUser});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String? serialNoScanResult;
  String? locationScanResult;
  final nameController = TextEditingController();
  final serialController = TextEditingController();
  final expiryController = TextEditingController();
  final acceptController = TextEditingController();
  final locationController = TextEditingController();
  late bool isAdded = false;

  @override
  void initState() {
    super.initState();

    log(widget.lastModifiedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 148, 146, 146))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide()),
                  hintText: 'Ürün Adı',
                  contentPadding: const EdgeInsets.all(20.0)),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: serialController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        scanBarcode();
                        setState(() {
                          serialNoScanResult = serialNoScanResult;
                          serialController.text = serialNoScanResult.toString();
                        });
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 30,
                      )),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide()),
                  hintText: 'Seri No',
                  contentPadding: const EdgeInsets.all(20.0)),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    keyboardType: TextInputType.datetime,
                    controller: expiryController,
                    inputFormatters: [
                      DateInputFormatter(),
                    ],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide()),
                        hintText: 'Son Kullanma Tarihi',
                        contentPadding: const EdgeInsets.all(20.0)),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: TextField(
                    controller: acceptController,
                    inputFormatters: [
                      DateInputFormatter(),
                    ],
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 0, 0))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide()),
                        hintText: 'Kabul Tarihi',
                        contentPadding: const EdgeInsets.all(20.0)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: locationController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        scanQR();
                        setState(() {
                          locationScanResult = locationScanResult;
                          locationController.text =
                              locationScanResult.toString();
                        });
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 30,
                      )),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide()),
                  hintText: 'Lokasyon Kodu',
                  contentPadding: const EdgeInsets.all(20.0)),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      String lastModifiedTime = Instant.now()
                          .inLocalZone()
                          .toString('yyyy-MM-dd HH:mm');
                      log(lastModifiedTime);
                      log("User: ${widget.lastModifiedUser}");
                      isAdded = await AuthService.addNewItem(
                          serialController.text,
                          expiryController.text,
                          acceptController.text,
                          locationController.text,
                          nameController.text,
                          piece,
                          isChecked,
                          lastModifiedTime,
                          widget.lastModifiedUser);
                      if (isAdded && mounted) {
                        log(isAdded.toString());
                        showMyDialog(context, 'Ürün başarıyla eklendi');
                        serialController.text = '';
                        expiryController.text = '';
                        acceptController.text = '';
                        locationController.text = '';
                        nameController.text = '';
                      } else {
                        showMyDialog(context, 'Bir hata oluştu');
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Ekle'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future scanBarcode() async {
    log('barcoda girdi');
    String serialNoScanResult;
    try {
      serialNoScanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'İptal', true, ScanMode.BARCODE);
    } catch (e) {
      serialNoScanResult = "Bir hata oluştu!";
    }
    if (!mounted) return;
    setState(() {
      this.serialNoScanResult = serialNoScanResult;
    });
  }

  Future scanQR() async {
    log('QR girdi');
    String locationScanResult;
    try {
      locationScanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'İptal', true, ScanMode.QR);
    } catch (e) {
      locationScanResult = "Bir hata oluştu!";
    }
    if (!mounted) return;
    setState(() {
      this.locationScanResult = locationScanResult;
    });
  }
}
