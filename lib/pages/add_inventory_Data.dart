import 'dart:developer';

import 'package:firebase_integrated_app/pages/add_inventory_Data_search_result.dart';
import 'package:firebase_integrated_app/utils/navigation.dart';
import 'package:firebase_integrated_app/utils/scan.dart';
import 'package:flutter/material.dart';

class AddInventoryData extends StatefulWidget {
  const AddInventoryData({super.key});

  @override
  State<AddInventoryData> createState() => _AddInventoryDataState();
}

final serialController = TextEditingController();

class _AddInventoryDataState extends State<AddInventoryData> {
  String? scanResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Gir'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: serialController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        scanResult = await scanBarcode();
                        if (scanResult != null) {
                          log(scanResult.toString());
                          serialController.text = scanResult.toString();
                        }
                      },
                      icon: const Icon(Icons.camera_alt_outlined)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 148, 146, 146))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(0, 36, 36, 36),
                      )),
                  hintText: 'Seri No',
                  contentPadding: const EdgeInsets.all(5.0)),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: MaterialButton(
                      onPressed: () {
                        if (serialController.text.isNotEmpty) {
                          Navigation.addRoute(
                              context, const AddInventorySearchResult());
                        } else {
                          _showMyDialog();
                        }
                      },
                      child: const Icon(Icons.arrow_forward)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Seri no boş olamaz'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
