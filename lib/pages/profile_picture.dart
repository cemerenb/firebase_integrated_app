import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  String imageUrl = " ";

  void pickUploadImageFromDirectory() async {
    final image =
        await ImagePicker().pickImage(source: ImageSource.gallery, maxHeight: 512, maxWidth: 512, imageQuality: 75);

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('ProfilePics')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('profilepic.jpg');

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl = value;
      });
    });
  }

  void pickUploadImageFromCamera() async {
    final image =
        await ImagePicker().pickImage(source: ImageSource.camera, maxHeight: 512, maxWidth: 512, imageQuality: 75);

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('ProfilePics')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('profilepic.jpg');

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  pickUploadImageFromDirectory();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: imageUrl == ' '
                        ? const Icon(
                            Icons.folder,
                            size: 40,
                            color: Colors.white,
                          )
                        : Image.network(imageUrl),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  pickUploadImageFromCamera();
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 80),
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: imageUrl == ' '
                        ? const Icon(
                            Icons.camera,
                            size: 40,
                            color: Colors.white,
                          )
                        : Image.network(imageUrl),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
