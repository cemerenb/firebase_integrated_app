import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

bool isAdmin = false;
bool isOwner = false;
int isLogedIn = 0;
String email = '';
String name = '';
String idNo = '';
String serialNo = '';
String userName = '';
String itemName = '';
String expiryDate = '';
String acceptDate = '';
String locationCode = '';
String lastModifiedUser = '';
String lastModifiedTime = '';
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

getOwnerStatus(String uid) {
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
        isOwner = data['isOwner'];

        // ignore: unnecessary_null_comparison
        if (isOwner != null) {
          // Now you can use the isAdmin value as needed
          log('isOwner: $isOwner');
        } else {
          log('isOwner field is null');
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
  return isOwner;
}

getLogedInStatus(String uid) async {
  await FirebaseFirestore.instance
      .collection('person')
      .doc(uid)
      .get()
      .then((DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null && documentSnapshot.exists) {
      // Cast data to Map<String, dynamic>
      var data = documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        // Access the isAdmin field value
        isLogedIn = data['isLogedIn'];

        // ignore: unnecessary_null_comparison
        if (isLogedIn != null) {
          // Now you can use the isAdmin value as needed
          log('isLogedIn: $isLogedIn');
        } else {
          log('isLogedIn field is null');
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
  return isLogedIn;
}

getEmail(String uid) {
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
        email = data['email'];

        // ignore: unnecessary_null_comparison
        if (email != null) {
          // Now you can use the isAdmin value as needed
          log('email: $email');
        } else {
          log('email field is null');
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
  return email;
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
          log('Username: $userName');
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
        lastModifiedUser = data['lastModifiedUser'] ?? '';
        lastModifiedTime = data['lastModifiedTimer'] ?? '';

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
  return [
    serialNo,
    expiryDate,
    acceptDate,
    locationCode,
    piece,
    isChecked,
    lastModifiedUser,
    lastModifiedTime
  ];
}
