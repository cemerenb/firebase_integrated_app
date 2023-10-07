import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pirim_depo/pages/add_Inventory_Data';
import 'package:pirim_depo/utils/dialog.dart';
import 'package:pirim_depo/utils/navigation.dart';
import 'package:flutter/material.dart';
import '../utils/text.dart';

import '../utils/add_item_search_result_item.dart';

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
                searchResultItem(
                    context, serialNoText, serialController, false),
                searchResultItem(
                    context, expiryDateText, expiryController, false),
                searchResultItem(
                    context, acceptDateText, acceptController, false),
                searchResultItem(
                    context, lastModifiedUserText, lastUserController, false),
                searchResultItem(
                    context, lastModifiedTimeText, lastTimeController, false),
                searchResultItem(
                    context, locationCodeText, locationController, true),
                searchResultItem(context, pieceText, pieceController, true),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        deleteButton(context),
                        updateItemButton(context),
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

  Container updateItemButton(BuildContext context) {
    return Container(
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
              showMyDialog(context, itemUpdated);
            }
            setState(() {});
          } catch (e) {
            showMyDialog(context, error);
            setState(() {});
          }
        },
        child: Text(
          save,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Container deleteButton(BuildContext context) {
    return Container(
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
              await deleteDialog(context, widget.name, widget.userName);
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
        child: Text(
          delete,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
