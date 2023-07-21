import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pirim_depo/pages/about.dart';
import 'package:pirim_depo/pages/admin_switch.dart';
import 'package:pirim_depo/pages/help.dart';
import 'package:pirim_depo/pages/settings.dart';
import 'package:pirim_depo/pages/starting_page.dart';
import 'package:pirim_depo/services/auth.dart';
import 'package:pirim_depo/utils/get_data_firestore.dart';
import 'package:pirim_depo/utils/navigation.dart';

import 'login_page.dart';

class Profile extends StatefulWidget {
  late String profileImageUrl;
  late String name;
  late String userName;

  Profile({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.userName,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late bool hasProfileImage = false;
  String profileImageUrl = '';
  String lastProfileImageUrl = '';
  late bool isVisible = false;
  var user = FirebaseAuth.instance.currentUser;
  var email = FirebaseAuth.instance.currentUser?.email.toString();
  var uid = FirebaseAuth.instance.currentUser!.uid.toString();

  @override
  void initState() {
    getIdNo(uid);

    isVisible = getOwnerStatus(uid);
    setState(() {});
    getImage();
    checkProfileImage();
    super.initState();
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

  Future<dynamic> bottomSheet(BuildContext context) {
    return showModalBottomSheet(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 122, 122, 122),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () {
                      pickUploadImage(true);

                      setState(() {
                        log('setState');
                      });
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
                      pickUploadImage(true);

                      setState(() {
                        log('setState');
                      });
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
      },
    );
  }

  pickUploadImage(bool chose) async {
    XFile? image;
    if (chose) {
      image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75,
      );
      await checkProfileImage();
    } else if (!chose) {
      image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75,
      );
      await checkProfileImage();
    }

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('${FirebaseAuth.instance.currentUser?.uid}.jpg');

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
            log('Profile name: ${widget.name}');
            log('Profile userName: ${widget.userName}');
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
        title: const Text('Profilim'),
      ),
      body: Center(
        child: Column(
          children: [
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
                        height: 150,
                        width: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: getImage().toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(profileImageUrl),
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              width: 150,
                              height: 150,
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
                    padding: const EdgeInsets.all(20.0),
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
                        height: 150,
                        width: 150,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
            Center(
              child: Text(
                widget.name.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Center(
              child: Text(
                '@${widget.userName.toString()}',
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
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(97, 168, 168, 168),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.keyboard_arrow_right),
                    ),
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigation.addRoute(context, const Help());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
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
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(97, 168, 168, 168),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.keyboard_arrow_right),
                    ),
                  ],
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigation.addRoute(context, const SettingsPage());
              },
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
            Visibility(
              visible: isVisible,
              child: MaterialButton(
                onPressed: () {
                  Navigation.addRoute(context, const AdminSwitchPage());
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(97, 168, 168, 168),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ],
                  ),
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
                await FirebaseFirestore.instance
                    .collection('person')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({'isLogedIn': 0});
                AuthService.signOut();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                }
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
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(187, 231, 113, 113),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.keyboard_arrow_right),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getImage() {
    checkProfileImage();
    return profileImageUrl;
  }
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
        borderSide: const BorderSide(color: Color.fromARGB(255, 66, 66, 66)),
      ),
      hintText: hintText,
      contentPadding: const EdgeInsets.all(15.0),
    ),
  );
}
