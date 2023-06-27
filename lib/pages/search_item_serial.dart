import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../lists/lists.dart';

class SearchSerial extends StatefulWidget {
  const SearchSerial({super.key});

  @override
  State<SearchSerial> createState() => _SearchSerialState();
}

class _SearchSerialState extends State<SearchSerial> {
  final _itemsBox = Hive.box('itemsBox');
  @override
  void initState() {
    readItems();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  Future<void> writeItem(int index, Item item) async {
    await _itemsBox.put(index, item.toJson());
  }

  void readItems() async {
    int itemCount = _itemsBox.length;
    if (itemCount > 0) {
      Iterable<String> itemsString = _itemsBox
          .valuesBetween(
            startKey: 0,
            endKey: itemCount - 1,
          )
          .cast();
      List<Item> items = itemsString
          .map(
            (String json) => Item.fromJson(json),
          )
          .toList();
      items = items;
    } else {
      for (int index = 0; index < items.length; index++) {
        await _itemsBox.put(index, items[index].toJson());
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    log("new frame");
    return Scaffold(
      appBar: AppBar(),
      body: homePageListView(),
      floatingActionButton: FittedBox(
        child: FloatingActionButton.extended(
          onPressed: () {},
          label: Text(
            (" burası neresi"),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }

  ListView homePageListView() {
    return ListView.builder(
        itemCount: itemList.length - 1,
        itemBuilder: (context, index) {
          Item item = items[index];
          return Card(
              child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 2, bottom: 2),
            child: ListTile(
              title: Text(
                  'Name: ${item.name} - Serial: ${item.serialNo.toString()}'),
              subtitle: SizedBox(
                  height: 20,
                  width: 200,
                  child: Text('${item.acceptDate} - ${item.expiryDate}')),
            ),
          ));
        });
  }

  InputDecoration formFieldDecoration() {
    return InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 148, 146, 146))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(0, 129, 129, 129),
            )),
        hintText: 'Search',
        contentPadding: const EdgeInsets.all(5.0));
  }

  set() {
    setState(() {});
  }
}
