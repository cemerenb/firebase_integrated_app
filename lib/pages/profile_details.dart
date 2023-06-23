import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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
  ref.getDownloadURL().then((value) {});
}

class _ProfileDetailsState extends State<ProfileDetails> {
  DateTime? _dateTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: () {}, child: const Text('Skip')),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            GestureDetector(
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
                child: const Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                autocorrect: true,
                decoration: textFormFieldDecoration(),
              ),
            ),
            GestureDetector(
              onTap: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1930),
                      lastDate: DateTime.now())
                  .then((date) {
                setState(() {
                  _dateTime = date!;
                });
              }),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              textAlign: TextAlign.left,
                              _dateTime == null
                                  ? "Birth Day"
                                  : _dateTime.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      color: const Color.fromARGB(
                                          255, 87, 87, 87))),
                        ),
                        const Spacer(),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration textFormFieldDecoration() {
    return InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 148, 146, 146))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black)),
        hintText: 'Full Name',
        contentPadding: const EdgeInsets.all(20.0));
  }
}
