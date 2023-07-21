import 'package:flutter/material.dart';
import 'package:pirim_depo/utils/text.dart';

import '../pages/add_inventory_data.dart';

Future<void> showMyDialog(context, String data) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

Future<void> deleteDialog(BuildContext context, name, userName) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(itemDeleted),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(okay),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddInventoryData(
                    name: name,
                    userName: userName,
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
