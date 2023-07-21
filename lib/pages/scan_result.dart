import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ScanResult extends StatefulWidget {
  final String serialNo;

  const ScanResult({Key? key, required this.serialNo}) : super(key: key);

  @override
  ScanResultState createState() => ScanResultState();
}

class ScanResultState extends State<ScanResult> {
  String serialNo = '';
  String name = '';
  String expiryDate = '';
  String acceptDate = '';
  String piece = '';
  String locationCode = '';
  String lastModifiedUser = '';
  String lastModifiedTime = '';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    log(widget.serialNo);
    getItemData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            setState(() {
              name = '';
              expiryDate = '';
              acceptDate = '';
              piece = '';
              locationCode = '';
              lastModifiedUser = '';
              lastModifiedTime = '';
              isChecked = false;
            });
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(name),
      ),
      body: name.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  searchResultItem(context, 'Seri No', serialNo),
                  searchResultItem(context, 'Son Kullanma Tarihi', expiryDate),
                  searchResultItem(context, 'Kabul Tarihi', acceptDate),
                  searchResultItem(context, 'Adet', piece),
                  searchResultItem(context, 'Lokasyon Kodu', locationCode),
                  searchResultItem(context, 'Son Değişiklik Yapan Kullanıcı',
                      lastModifiedUser),
                  searchResultItem(
                      context, 'Son Değişiklik Tarihi', lastModifiedTime),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Ürün Bulunamadı',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget searchResultItem(BuildContext context, String data, String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.11,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  data,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.black),
            ),
            height: 45,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getItemData() {
    FirebaseFirestore.instance
        .collection('items')
        .doc(widget.serialNo)
        .get()
        .then((DocumentSnapshot? documentSnapshot) {
      if (documentSnapshot != null && documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            serialNo = data['serialNo'] ?? '';
            name = data['name'] ?? '';
            expiryDate = data['expiryDate'] ?? '';
            acceptDate = data['acceptDate'] ?? '';
            locationCode = data['locationCode'] ?? '';
            piece = data['piece'].toString();
            isChecked = data['isChecked'] ?? '';
            lastModifiedUser = data['lastModifiedUser'] ?? '';
            lastModifiedTime = data['lastModifiedTime'] ?? '';
          });

          if (name.isNotEmpty) {
            log('Id No: $name');
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
  }
}
