import 'dart:developer';

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pirim_depo/pages/add_inventory_data.dart';
import 'package:pirim_depo/pages/add_item.dart';
import 'package:pirim_depo/pages/profile.dart';
import 'package:pirim_depo/pages/scan_result.dart';
import 'package:pirim_depo/pages/search_item_name.dart';
import 'package:pirim_depo/utils/get_data_firestore.dart';
import 'package:pirim_depo/utils/scan.dart';
import 'package:pirim_depo/utils/navigation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../theme/theme_manager.dart';

ThemeManager _themeManager = ThemeManager();

class StartPage extends StatefulWidget {
  final String email;
  final String name;
  final String userName;
  bool isAdmin;

  StartPage(
      {Key? key,
      required this.email,
      required this.isAdmin,
      required this.name,
      required this.userName})
      : super(key: key);
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
  late String name = '';
  late String userName = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      widget.isAdmin = getAdminStatus(FirebaseAuth.instance.currentUser!.uid);
    });

    getImage();
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
          title: const Text("Ana Sayfa"),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color: const Color.fromARGB(97, 168, 168, 168),
                height: 1,
                width: MediaQuery.of(context).size.width,
              )),
          actions: [
            hasProfileImage
                ? GestureDetector(
                    onTap: () async {
                      userName = await getUserName(
                          FirebaseAuth.instance.currentUser!.uid);

                      name =
                          await getName(FirebaseAuth.instance.currentUser!.uid);
                      Timer.run(() {
                        if (mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                  profileImageUrl: profileImageUrl.toString(),
                                  name: name,
                                  userName: userName,
                                ),
                              ));
                        }
                      });
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
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    getImage().toString(),
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const CircularProgressIndicator(),
                            ),
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
                      onTap: () async {
                        userName = await getUserName(
                            FirebaseAuth.instance.currentUser!.uid);
                        name = await getName(
                            FirebaseAuth.instance.currentUser!.uid);
                        if (mounted) {
                          Navigation.addRoute(
                              context,
                              Profile(
                                profileImageUrl: profileImageUrl.toString(),
                                name: name,
                                userName: userName,
                              ));
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
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
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
          child: Column(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Row(
                  children: [
                    Flexible(
                      flex: 6,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          log(userName.toString());
                          Navigation.addRoute(
                              context,
                              AddItem(
                                lastModifiedUser: userName.toString(),
                                name: widget.name,
                                userName: widget.userName,
                              ));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          height: 250,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/img/bg.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 161, 161, 161),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 100,
                              ),
                              Container(),
                              Container(),
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      'Ürün Ekle',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 27,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          Navigation.addRoute(
                              context,
                              AddInventoryData(
                                name: widget.name,
                                userName: widget.userName,
                              ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/img/bg2.jpg'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.srgbToLinearGamma()),
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 161, 161, 161),
                          ),
                          child: const Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 30.0),
                                child: Text(
                                  'Stok Gir',
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      flex: 6,
                      fit: FlexFit.tight,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                                image: AssetImage('assets/img/bg3.jpg'),
                                colorFilter: ColorFilter.srgbToLinearGamma(),
                                fit: BoxFit.cover)),
                        child: ClipRRect(
                          child: Column(
                            children: [
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      fit: FlexFit.tight,
                                      child: GestureDetector(
                                        onTap: () => Navigation.addRoute(
                                            context, const SearchByName()),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                0, 161, 161, 161),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.search,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'Ürün Ara',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      color: Theme.of(context).canvasColor,
                                      width: 10,
                                    ),
                                    Flexible(
                                      flex: 3,
                                      fit: FlexFit.tight,
                                      child: GestureDetector(
                                        onTap: () async {
                                          scanResult = await scanQR();
                                          log("Scan ${scanResult.toString()}");
                                          if (mounted) {
                                            Navigation.addRoute(
                                                context,
                                                ScanResult(
                                                    serialNo:
                                                        scanResult ?? ''));
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                0, 161, 161, 161),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Column(
                                            children: [
                                              Spacer(),
                                              Icon(
                                                Icons.qr_code_scanner,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'QR Tara',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Theme.of(context).canvasColor,
                                height: 10,
                              ),
                              Flexible(
                                flex: 3,
                                fit: FlexFit.tight,
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 6,
                                      fit: FlexFit.tight,
                                      child: GestureDetector(
                                        onTap: () async {
                                          scanResult = await scanBarcode();
                                          log("Scan ${scanResult.toString()}");
                                          if (mounted) {
                                            Navigation.addRoute(
                                                context,
                                                ScanResult(
                                                    serialNo:
                                                        scanResult ?? ''));
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                0, 161, 161, 161),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Column(
                                            children: [
                                              Spacer(),
                                              Icon(
                                                Icons.camera_alt_outlined,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'Barkod Tara',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
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
                  ],
                ),
              ),
              Flexible(fit: FlexFit.tight, flex: 2, child: Container())
            ],
          ),
        ),
      ),
    );
  }

  getImage() {
    checkProfileImage();
    return profileImageUrl;
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Çıkış yap'),
            content: const Text('Uygulamadan çıkmak istiyor musunuz?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
