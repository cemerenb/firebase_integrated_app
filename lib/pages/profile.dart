import 'dart:developer';
import 'dart:io';
import 'package:pirim_depo/pages/about.dart';
import 'package:pirim_depo/pages/admin_switch.dart';
import 'package:pirim_depo/pages/help.dart';
import 'package:pirim_depo/pages/starting_page.dart';
import 'package:pirim_depo/utils/get_data_firestore.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth.dart';
import '../utils/navigation.dart';
import 'login_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required String profileImageUrl}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late bool hasProfileImage = false;
  String profileImageUrl = "";
  var user = FirebaseAuth.instance.currentUser;
  var email = FirebaseAuth.instance.currentUser?.email.toString();
  var uid = FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  void initState() {
    super.initState();
    getUserName(uid);
    name = getName(uid);
    getIdNo(uid);
    checkProfileImage();
  }

  Future<void> checkProfileImage() async {
    Reference ref = FirebaseStorage.instance.ref().child("${user?.uid}.jpg");
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

  Future<dynamic> bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 212, 211, 211),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        pickUploadImage(true);
                      },
                      child: const SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20),
                              child: Icon(
                                Icons.photo_camera,
                                size: 30,
                              ),
                            ),
                            Text(
                              'Kamera',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        pickUploadImage(false);
                      },
                      child: const SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 20),
                              child: Icon(
                                Icons.photo,
                                size: 30,
                              ),
                            ),
                            Text(
                              'Galeri',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void pickUploadImage(bool chose) async {
    XFile? image;
    if (chose) {
      image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75,
      );
    } else if (!chose) {
      image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75,
      );
    }

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${FirebaseAuth.instance.currentUser?.uid}.jpg");

    await ref.putFile(File(image!.path));
    String downloadUrl = await ref.getDownloadURL();
    if (downloadUrl.isNotEmpty) {
      setState(() {
        profileImageUrl = downloadUrl;
        hasProfileImage = true;
      });
    }
    final imageBytes = await ref.getData(10000000);

    // Put the image file in the cache
    await DefaultCacheManager().putFile(profileImageUrl, imageBytes!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () async {
              Navigation.addRoute(
                  context,
                  StartPage(
                      email: getEmail(FirebaseAuth.instance.currentUser!.uid),
                      isAdmin: getAdminStatus(
                          FirebaseAuth.instance.currentUser!.uid)));
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Profilim'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                  onTap: () {
                    bottomSheet(context);
                  },
                  child: SizedBox(
                      height: 150,
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: hasProfileImage
                            ? CachedNetworkImage(
                                key: UniqueKey(),
                                imageUrl: profileImageUrl,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(
                                  strokeWidth: 20,
                                  color: Colors.black,
                                ),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 150,
                                width: 150,
                                decoration: const BoxDecoration(
                                    color: Colors.grey, shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.black,
                                ),
                              ),
                      ))),
            ),
            Center(
              child: Text(
                name.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Center(
              child: Text(
                "@${userName.toString()}",
                style: const TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Container(
                color: const Color.fromARGB(97, 168, 168, 168),
                height: 1,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            MaterialButton(
              onPressed: () {},
              child: SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.settings_outlined,
                      size: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Ayarlar',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                    Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(97, 168, 168, 168),
                            borderRadius: BorderRadius.circular(9)),
                        child: const Icon(Icons.keyboard_arrow_right))
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigation.addRoute(context, const About());
              },
              child: SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Hakkında',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                    Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(97, 168, 168, 168),
                            borderRadius: BorderRadius.circular(9)),
                        child: const Icon(Icons.keyboard_arrow_right))
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigation.addRoute(context, const Help());
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 70,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.help_outline,
                      size: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Yardım',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                    Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(97, 168, 168, 168),
                            borderRadius: BorderRadius.circular(9)),
                        child: const Icon(Icons.keyboard_arrow_right))
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigation.addRoute(context, const AdminSwitchPage());
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 70,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Yönetici Paneli',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                    Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(97, 168, 168, 168),
                            borderRadius: BorderRadius.circular(9)),
                        child: const Icon(Icons.keyboard_arrow_right))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                color: const Color.fromARGB(97, 168, 168, 168),
                height: 1,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            MaterialButton(
              onPressed: () async {
                AuthService.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const LoginPage()),
                  (route) => false,
                );
              },
              child: SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.logout_outlined,
                      size: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Çıkış Yap',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                    Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(187, 231, 113, 113),
                            borderRadius: BorderRadius.circular(9)),
                        child: const Icon(Icons.keyboard_arrow_right))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField inputDecoration(String hintText) {
    log(hintText);
    return TextField(
      enabled: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 66, 66, 66))),
          hintText: hintText,
          contentPadding: const EdgeInsets.all(15.0)),
    );
  }
}
