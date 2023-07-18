import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:pirim_depo/pages/add_inventory_data.dart';
import 'package:pirim_depo/pages/add_item.dart';
import 'package:pirim_depo/pages/profile.dart';
import 'package:pirim_depo/pages/scan_result.dart';
import 'package:pirim_depo/pages/search_item_name.dart';
import 'package:pirim_depo/utils/get_data_firestore.dart';
import 'package:pirim_depo/utils/scan.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../utils/navigation.dart';

// ignore: must_be_immutable
class StartPage extends StatefulWidget {
  final String email;
  bool isAdmin;

  StartPage({super.key, required this.email, required this.isAdmin});
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

    setState(() {
      widget.isAdmin = getAdminStatus(FirebaseAuth.instance.currentUser!.uid);
    });

    getImage();
    getUserName(FirebaseAuth.instance.currentUser!.uid);
    checkProfileImage();
    setState(() {});
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
    return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Ana Sayfa",
            ),
            actions: [
              hasProfileImage
                  ? GestureDetector(
                      onTap: () {
                        Navigation.addRoute(
                            context,
                            Profile(
                                profileImageUrl: profileImageUrl.toString()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: getImage().toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          getImage().toString(),
                                        ))),
                              ),
                              placeholder: (context, url) => Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  child: const CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigation.addRoute(
                              context,
                              Profile(
                                  profileImageUrl: profileImageUrl.toString()));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
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
            ],
          ),
          body: SingleChildScrollView(
            child: Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        log(userName.toString());
                        Navigation.addRoute(context,
                            AddItem(lastModifiedUser: userName.toString()));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          height: 250,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 94, 94, 94),
                                blurRadius: 2,
                                offset: Offset(1, 1), // Shadow position
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
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
                    GestureDetector(
                      onTap: () {
                        Navigation.addRoute(context, const AddInventoryData());
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigation.addRoute(
                              context, const SearchByName()),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 161, 161, 161),
                                borderRadius: BorderRadius.circular(8)),
                            height: 120,
                            width: MediaQuery.of(context).size.width / 4.9,
                            child: const Column(
                              children: [
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Ürün Adı ile Ara',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            scanResult = await scanQR();
                            log("Scan ${scanResult.toString()}");
                            if (mounted) {
                              Navigation.addRoute(context,
                                  ScanResult(serialNo: scanResult ?? ''));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 161, 161, 161),
                                borderRadius: BorderRadius.circular(8)),
                            height: 120,
                            width: MediaQuery.of(context).size.width / 4.9,
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
                    Visibility(
                      visible: isAdmin,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 161, 161, 161),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 100,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isAdmin,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: 250,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  getImage() {
    checkProfileImage();
    return profileImageUrl;
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Çıkış yap'),
            content: const Text('Uygulamadan çıkmak istiyor musunuz?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}
