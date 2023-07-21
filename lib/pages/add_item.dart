import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pirim_depo/pages/starting_page.dart';
import 'package:pirim_depo/services/auth.dart';
import 'package:pirim_depo/utils/dialog.dart';
import 'package:pirim_depo/utils/navigation.dart';
import 'package:pirim_depo/utils/get_data_firestore.dart';
import 'package:pirim_depo/utils/text.dart';
import 'package:time_machine/time_machine.dart';

import '../utils/text_fields.dart';

class AddItem extends StatefulWidget {
  final String lastModifiedUser;
  final String name;
  final String userName;

  const AddItem(
      {Key? key,
      required this.lastModifiedUser,
      required this.name,
      required this.userName})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String? serialNoScanResult;
  String? locationScanResult;
  final nameController = TextEditingController();
  final serialController = TextEditingController();
  final expiryController = TextEditingController();
  final acceptController = TextEditingController();
  final locationController = TextEditingController();
  bool isAdded = false;

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
                isAdmin: getAdminStatus(FirebaseAuth.instance.currentUser!.uid),
                name: widget.name,
                userName: widget.userName,
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            AddItemNameTextField(nameController: nameController),
            const SizedBox(height: 30),
            addItemSerialNoTextField(context),
            const SizedBox(height: 30),
            AddItemExpiryDateTextField(
                expiryController: expiryController,
                acceptController: acceptController),
            const SizedBox(height: 30),
            addItemLocationCodeTextField(),
            const Spacer(),
            addItem(context)
          ],
        ),
      ),
    );
  }

  Row addItem(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () async {
                String lastModifiedTime =
                    Instant.now().inLocalZone().toString('yyyy-MM-dd HH:mm');
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
                  widget.lastModifiedUser,
                );
                if (isAdded && mounted) {
                  log(isAdded.toString());
                  showMyDialog(context, itemAdded);
                  serialController.text = '';
                  expiryController.text = '';
                  acceptController.text = '';
                  locationController.text = '';
                  nameController.text = '';
                } else {
                  showMyDialog(context, error);
                }
                setState(() {});
              },
              icon: const Icon(Icons.add),
              label: Text(add),
            ),
          ),
        ),
      ],
    );
  }

  Padding addItemLocationCodeTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(),
          ),
          hintText: locationCodeText,
          contentPadding: const EdgeInsets.all(20.0),
        ),
      ),
    );
  }

  Padding addItemSerialNoTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(),
          ),
          hintText: serialNoText,
          contentPadding: const EdgeInsets.all(20.0),
        ),
      ),
    );
  }

  Future scanBarcode() async {
    log('barcoda girdi');
    String serialNoScanResult;
    try {
      serialNoScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        cancel,
        true,
        ScanMode.BARCODE,
      );
    } catch (e) {
      serialNoScanResult = error;
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
        '#ff6666',
        cancel,
        true,
        ScanMode.QR,
      );
    } catch (e) {
      locationScanResult = error;
    }
    if (!mounted) return;
    setState(() {
      this.locationScanResult = locationScanResult;
    });
  }
}
