import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integrated_app/pages/accept_term.dart';
import 'package:firebase_integrated_app/pages/add_item.dart';
import 'package:firebase_integrated_app/pages/profile.dart';
import 'package:firebase_integrated_app/pages/search_item_serial.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../utils/navigation.dart';

// ignore: must_be_immutable
class StartPage extends StatefulWidget {
  final String email;
  StartPage({super.key, required this.email});
  final auth = FirebaseAuth.instance;
  final bool isverify = false;
  User? user;
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String? scanResult;
  String? profileImageUrl;
  late bool hasProfileImage = false;
  @override
  void initState() {
    super.initState();
    setState(() {});
    checkProfileImage();
  }

  Future<void> checkProfileImage() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${FirebaseAuth.instance.currentUser?.uid}.jpg");
    try {
      String downloadUrl = await ref.getDownloadURL();
      if (downloadUrl.isNotEmpty) {
        setState(() {
          profileImageUrl = downloadUrl;
          hasProfileImage = true;
        });
      }
    } catch (e) {
      setState(() {
        hasProfileImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            title: Text(
              "Ana Sayfa",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            actions: [
              MaterialButton(
                onPressed: () => Navigation.addRoute(
                  context,
                  Profile(profileImageUrl: profileImageUrl ?? ''),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: hasProfileImage
                        ? SizedBox(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              radius: 40,
                              foregroundImage:
                                  NetworkImage(getImage().toString()),
                            ),
                          )
                        : Container(
                            height: 40,
                            width: 40,
                            decoration: const BoxDecoration(
                                color: Colors.grey, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigation.addRoute(context, const AddItem()),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 161, 161, 161),
                              ),
                              child: const Column(
                                children: [
                                  Spacer(),
                                  Icon(
                                    Icons.add,
                                    size: 100,
                                  ),
                                  Text(
                                    'Ürün Ekle',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  Spacer(),
                                ],
                              )),
                        ),

                        //Scan qr and barcode button

                        Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.transparent),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigation.addRoute(
                                          context, const SearchSerial()),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 161, 161, 161),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.9,
                                        child: const Column(
                                          children: [
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                'Seri No ile Ara',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: scanQr,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 161, 161, 161),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4.9,
                                        child: const Column(
                                          children: [
                                            Spacer(),
                                            Icon(
                                              Icons.qr_code_2_outlined,
                                              size: 50,
                                            ),
                                            Text(
                                              'QR Tara',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: scanBarcode,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 161, 161, 161),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      height: 120,
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: const Column(
                                        children: [
                                          Spacer(),
                                          Icon(
                                            Icons.camera_alt_outlined,
                                            size: 50,
                                          ),
                                          Text(
                                            'Barkod Tara',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Spacer()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigation.addRoute(context, const AcceptTerm()),
                          child: Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 161, 161, 161),
                              ),
                              child: const Column(
                                children: [
                                  Spacer(),
                                  Icon(
                                    Icons.shelves,
                                    size: 100,
                                  ),
                                  Text(
                                    'Stok Gir',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  Spacer(),
                                ],
                              )),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 161, 161, 161),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future scanBarcode() async {
    log('barcoda girdi');
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'İptal', true, ScanMode.BARCODE);
    } catch (e) {
      scanResult = "Bir hata oluştu!";
    }
    if (!mounted) return;
    setState(() {
      this.scanResult = scanResult;
    });
  }

  Future scanQr() async {
    log('barcoda girdi');
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'İptal', true, ScanMode.QR);
    } catch (e) {
      scanResult = "Bir hata oluştu!";
    }
    if (!mounted) return;
    setState(() {
      this.scanResult = scanResult;
    });
  }

  getImage() {
    checkProfileImage();
    log(profileImageUrl.toString());
    return profileImageUrl;
  }
}
