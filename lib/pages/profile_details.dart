


import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}
void pickUploadImage() async {
  final image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxHeight: 512,
    maxWidth: 512,
    imageQuality: 75,
  );
  Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");

  await ref.putFile(File(image!.path));
  ref.getDownloadURL().then((value) {
    print(value);
  });
}
class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: GestureDetector(
              onTap: () {
                pickUploadImage();
              },
              child: Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  color: Colors.grey,
                ),
                child: Icon(Icons.person,size: 80, color: Colors.black,),
              ),
            ),

    );
  }
}
