import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Person {
  final String email;
  bool isAdmin;

  Person({required this.email, required this.isAdmin});

  factory Person.fromMap(Map<String, dynamic>? map) {
    return Person(
      email: map?['email'] ?? '',
      isAdmin: map?['isAdmin'] ?? false,
    );
  }
}

class AdminSwitchPage extends StatefulWidget {
  const AdminSwitchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminSwitchPageState createState() => _AdminSwitchPageState();
}

class _AdminSwitchPageState extends State<AdminSwitchPage> {
  final CollectionReference personCollection =
      FirebaseFirestore.instance.collection('person');

  List<Person> personList = [];

  @override
  void initState() {
    super.initState();
    fetchPersons();
  }

  Future<void> fetchPersons() async {
    final snapshot = await personCollection.get();
    final List<Person> persons = snapshot.docs
        .map((doc) => Person.fromMap(doc.data() as Map<String, dynamic>?))
        .toList();
    setState(() {
      personList = persons;
    });
  }

  toggleAdminStatus(int index, bool value) async {
    final person = personList[index];
    person.isAdmin = value;
    await personCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'isAdmin': value});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Switch'),
      ),
      body: ListView.builder(
        itemCount: personList.length,
        itemBuilder: (context, index) {
          final person = personList[index];
          return ListTile(
            title: Text(person.email),
            trailing: Switch(
              value: person.isAdmin,
              onChanged: (value) async {
                await toggleAdminStatus(index, value);
                setState(() {});
                log(person.isAdmin.toString());
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.red,
            ),
          );
        },
      ),
    );
  }
}
