import 'dart:io';
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

  @override
  void initState() {
    super.initState();
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
            onPressed: () {
              Navigation.popRoute(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Profilim'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () async {
              AuthService.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => const LoginPage()),
                (route) => false,
              );
            },
          )
        ],
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
                                  strokeWidth: 15,
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
          ],
        ),
      ),
    );
  }
}
