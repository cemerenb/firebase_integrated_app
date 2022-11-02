import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static FirebaseAuth get _auth => FirebaseAuth.instance;
  static FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  static signOut() async {
    return await _auth.signOut();
  }

  static FindUser() {
    var user = _auth.currentUser;
    return user;
  }

  static Future<User?> createPerson(String username, String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection('person').doc(user.user!.uid).set({
      'userName': username,
      'email': email,
    });
    return user.user;
  }
}
