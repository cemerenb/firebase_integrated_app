import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../lists/lists.dart';

class SearchSerial extends StatefulWidget {
  const SearchSerial({Key? key}) : super(key: key);

  @override
  State<SearchSerial> createState() => _SearchSerialState();
}

class _SearchSerialState extends State<SearchSerial> {
  bool isVisible = false;
  bool isCategorised = false;
  final priceController = TextEditingController();
  final myController = TextEditingController();
  final searchController = TextEditingController();
  final serialController = TextEditingController();
  final _itemsBox = Hive.box('itemsBox');
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    readItems();
  }

  @override
  void dispose() {
    myController.dispose();
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
      List<Item> existingItems = itemsString
          .map(
            (String json) => Item.fromJson(json),
          )
          .toList();
      setState(() {
        items.addAll(existingItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Visibility(
          visible: isVisible,
          child: TextFormField(
            controller: searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: formFieldDecoration(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              icon: const Icon(
                Icons.search,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: homePageListView(),
    );
  }

  ListView homePageListView() {
    log(searchController.text);
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          if (itemList.isNotEmpty) {
            Item item = items[index];
            bool shouldFilter = searchController.text.isNotEmpty;
            if (shouldFilter) {
              bool isMatch = item.name
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase());
              if (!isMatch) {
                return const SizedBox();
              }
            }

            return Card(
                child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 2, bottom: 2),
              child: ListTile(
                title: SizedBox(height: 20, width: 200, child: Text(item.name)),
                subtitle: SizedBox(
                    height: 20, width: 200, child: Text('${item.piece} adet')),
                trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.acceptDate,
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        item.expiryDate,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ));
          }
          return const SizedBox();
        });
  }

  InputDecoration formFieldDecoration() {
    return InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 148, 146, 146))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(0, 129, 129, 129),
            )),
        hintText: 'Ara',
        contentPadding: const EdgeInsets.all(5.0));
  }

  set() {
    setState(() {});
  }
}
