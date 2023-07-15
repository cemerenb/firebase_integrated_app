import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

bool isAdmin = false;
String name = '';
String idNo = '';
String serialNo = '';
String userName = '';
String itemName = '';
String expiryDate = '';
String acceptDate = '';
String locationCode = '';
int piece = 0;
bool isChecked = true;

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

        // ignore: unnecessary_null_comparison
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

getName(String uid) {
  FirebaseFirestore.instance
      .collection('person')
      .doc(uid)
      .get()
      .then((DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null && documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        name = data['name'] ?? '';

        if (name.isNotEmpty) {
          log('Name: $name');
        } else {
          log('Name field is empty');
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
  return name;
}

getIdNo(String uid) {
  FirebaseFirestore.instance
      .collection('person')
      .doc(uid)
      .get()
      .then((DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null && documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        idNo = data['idNo'] ?? '';

        if (idNo.isNotEmpty) {
          log('Id No: $idNo');
        } else {
          log('Id No field is empty');
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
  return idNo;
}

getUserName(String uid) {
  FirebaseFirestore.instance
      .collection('person')
      .doc(uid)
      .get()
      .then((DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null && documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        userName = data['userName'] ?? '';

        if (userName.isNotEmpty) {
          log('Id No: $userName');
        } else {
          log('Id No field is empty');
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
  return userName;
}

getItemData(String serialNo) {
  FirebaseFirestore.instance
      .collection('items')
      .doc(serialNo)
      .get()
      .then((DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null && documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        serialNo = data['serialNo'] ?? '';
        itemName = data['name'] ?? '';
        expiryDate = data['expiryDate'] ?? '';
        acceptDate = data['acceptDate'] ?? '';
        locationCode = data['locationCode'] ?? '';
        piece = data['piece'] ?? '';
        isChecked = data['isChecked'] ?? '';

        if (userName.isNotEmpty) {
          log('Id No: $userName');
        } else {
          log('Id No field is empty');
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
  return [serialNo, expiryDate, acceptDate, locationCode, piece, isChecked];
}
