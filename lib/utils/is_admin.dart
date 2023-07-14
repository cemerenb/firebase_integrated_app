import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

bool isAdmin = false;
getAdminStatus(String uid) {
  FirebaseFirestore.instance
      .collection('person')
      .doc(uid)
      .get()
      .then((DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null && documentSnapshot.exists) {
      // Cast data to Map<String, dynamic>
      var data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Access the isAdmin field value
        isAdmin = data['isAdmin'];

        if (isAdmin != null) {
          // Now you can use the isAdmin value as needed
          log('isAdmin: $isAdmin');
        } else {
          log('isAdmin field is null');
        }
      } else {
        log('Document data is null');
      }
    } else {
      log('No such document!');
    }
  }).catchError((error) {
    log('Error getting document: $error');
  });
  return isAdmin;
}
