import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static FirebaseAuth get _auth => FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();
  static FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  static signOut() async {
    return await _auth.signOut();
  }

  static findUser() {
    var user = _auth.currentUser;
    return user;
  }

  static Future<User?> createPerson(
      String username,
      String email,
      String password,
      bool isAdmin,
      String name,
      String idno,
      bool isOwner,
      int isLogedIn) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _firestore.collection('person').doc(user.user!.uid).set({
      'userName': username,
      'email': email,
      'isAdmin': isAdmin,
      'name': name,
      'idNo': idno,
      'isOwner': isOwner,
      'isLogedIn': isLogedIn,
    });
    return user.user;
  }

  static Future<bool> addNewItem(
      String serialNo1,
      String expiryDate1,
      String acceptDate1,
      String locationCode1,
      String itemName1,
      int piece1,
      bool isChecked1,
      String lastModifiedTime,
      String lastModifiedUser) async {
    bool isAdded = false;
    log(lastModifiedUser);
    try {
      await _firestore.collection('items').doc(serialNo1).set({
        'expiryDate': expiryDate1,
        'acceptDate': acceptDate1,
        'locationCode': locationCode1,
        'name': itemName1,
        'serialNo': serialNo1,
        'piece': piece1,
        'isChecked': isChecked1,
        'lastModifiedTime': lastModifiedTime,
        'lastModifiedUser': lastModifiedUser
      });
      isAdded = true;
    } catch (e) {
      isAdded = false;
    }

    return isAdded;
  }
}
