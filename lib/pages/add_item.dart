import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pirim_depo/pages/starting_page.dart';
import 'package:pirim_depo/utils/dialog.dart';
import 'package:pirim_depo/utils/get_data_firestore.dart';
import 'package:pirim_depo/utils/navigation.dart';
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
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigation.addRoute(
                  context,
                  StartPage(
                      email: getEmail(FirebaseAuth.instance.currentUser!.uid),
                      isAdmin: getAdminStatus(
                          FirebaseAuth.instance.currentUser!.uid)));
            },
            icon: const Icon(Icons.arrow_back)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: TextField(
              controller: nameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
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
              textInputAction: TextInputAction.next,
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      onTap: () async {
                        await scanBarcode();
                        if (serialNoScanResult != '-1') {
                          serialNoScanResult = serialNoScanResult;
                          serialController.text = serialNoScanResult.toString();
                        }
                        setState(() {});
                      },
                      child: const Icon(
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
                    textInputAction: TextInputAction.next,
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
                    textInputAction: TextInputAction.next,
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
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                      onTap: () async {
                        await scanBarcode();
                        if (serialNoScanResult != '-1') {
                          serialNoScanResult = serialNoScanResult;
                          serialController.text = serialNoScanResult.toString();
                        }
                        setState(() {});
                      },
                      child: const Icon(
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
