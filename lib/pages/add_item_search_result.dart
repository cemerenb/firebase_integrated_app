import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pirim_depo/pages/add_inventory_data.dart';
import 'package:pirim_depo/utils/dialog.dart';
import 'package:pirim_depo/utils/navigation.dart';
import 'package:flutter/material.dart';

class AddInventorySearchResult extends StatefulWidget {
  final String itemName;
  final String serialNo;
  final String expiryDate;
  final String acceptDate;
  final String piece;
  final String locationCode;
  final String lastModifiedTime;
  final String lastModifiedUser;
  final String name;
  final String userName;

  const AddInventorySearchResult({
    Key? key,
    required this.itemName,
    required this.serialNo,
    required this.expiryDate,
    required this.acceptDate,
    required this.piece,
    required this.locationCode,
    required this.lastModifiedTime,
    required this.lastModifiedUser,
    required this.name,
    required this.userName,
  }) : super(key: key);

  @override
  State<AddInventorySearchResult> createState() =>
      _AddInventorySearchResultState();
}

final serialController = TextEditingController();
final itemNameController = TextEditingController();
final expiryController = TextEditingController();
final acceptController = TextEditingController();
final pieceController = TextEditingController();
final locationController = TextEditingController();
final lastUserController = TextEditingController();
final lastTimeController = TextEditingController();

class _AddInventorySearchResultState extends State<AddInventorySearchResult> {
  @override
  void initState() {
    serialController.text = widget.serialNo;
    itemNameController.text = widget.itemName;
    expiryController.text = widget.expiryDate;
    acceptController.text = widget.acceptDate;
    pieceController.text = widget.piece;
    locationController.text = widget.locationCode;
    lastUserController.text = widget.lastModifiedUser;
    lastTimeController.text = widget.lastModifiedTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigation.addRoute(
                context,
                AddInventoryData(
                  name: widget.name,
                  userName: widget.userName,
                ));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.itemName),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                searchResultItem(context, 'Seri No', serialController, false),
                searchResultItem(
                    context, 'Son Kullanma Tarihi', expiryController, false),
                searchResultItem(
                    context, 'Kabul Tarihi', acceptController, false),
                searchResultItem(context, 'Son Değişiklik Yapan Kullanıcı',
                    lastUserController, false),
                searchResultItem(context, 'Son Değişiklik Tarihi',
                    lastTimeController, false),
                searchResultItem(
                    context, 'Lokasyon Kodu', locationController, true),
                searchResultItem(context, 'Adet', pieceController, true),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('items')
                                  .doc(serialController.text)
                                  .delete();

                              log('item deleted');
                              if (mounted) {
                                setState(() async {
                                  await showDeleteDialog(
                                      context, 'Ürün başarıyla silindi');
                                });

                                Navigation.addRoute(
                                  context,
                                  AddInventoryData(
                                    name: widget.name,
                                    userName: widget.userName,
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Sil',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 145, 145, 145),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(serialController.text)
                                    .update({'piece': pieceController.text});
                                await FirebaseFirestore.instance
                                    .collection('items')
                                    .doc(serialController.text)
                                    .update({
                                  'locationCode': locationController.text,
                                });

                                if (mounted) {
                                  showMyDialog(
                                      context, 'Ürün başarıyla güncellendi');
                                }
                                setState(() {});
                              } catch (e) {
                                showMyDialog(context, 'Bir hata oldu');
                                setState(() {});
                              }
                            },
                            child: const Text(
                              'Kaydet',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox searchResultItem(
    BuildContext context,
    String data,
    TextEditingController text,
    bool isEnabled,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
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
          TextField(
            enabled: isEnabled,
            controller: text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 148, 146, 146),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 148, 146, 146),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black),
              ),
              contentPadding: const EdgeInsets.all(20.0),
            ),
          )
        ],
      ),
    );
  }

  Future<void> showDeleteDialog(BuildContext context, String data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(data),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tamam'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddInventoryData(
                      name: widget.name,
                      userName: widget.userName,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
