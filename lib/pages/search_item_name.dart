import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pirim_depo/pages/search_result.dart';
import 'package:pirim_depo/utils/navigation.dart';
import 'package:flutter/material.dart';

class SearchByName extends StatefulWidget {
  const SearchByName({Key? key})
      : super(
          key: key,
        );

  @override
  State<SearchByName> createState() => _SearchSerialState();
}

class _SearchSerialState extends State<SearchByName> {
  bool isVisible = false;
  bool isCategorised = false;
  final priceController = TextEditingController();
  final myController = TextEditingController();
  final searchController = TextEditingController();
  final serialController = TextEditingController();

  List<DocumentSnapshot> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(child: homePageListView()),
    );
  }

  Future<void> fetchItems() async {
    try {
      final QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('items').get();
      final List<DocumentSnapshot> documents = snapshot.docs;
      setState(() {
        items = documents;
        isLoading = false;
      });
    } catch (error) {
      log('Error fetching items: $error');
    }
  }

  Widget homePageListView() {
    List<DocumentSnapshot> filteredItems = items.where((item) {
      String searchText = searchController.text.toLowerCase();
      String itemName = item['name'].toString().toLowerCase();
      return itemName.contains(searchText);
    }).toList();
    log(searchController.text);

    if (filteredItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Gösterilecek Ürün Yok',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final DocumentSnapshot item = filteredItems[index];
        final String serialNo = item['serialNo'];
        final String itemName = item['name'];
        final String piece = item['piece'].toString();
        final String acceptDate = item['acceptDate'];
        final String expiryDate = item['expiryDate'];
        final String locationCode = item['locationCode'];
        final String lastModifiedTime = item['lastModifiedTime'];
        final String lastModifiedUser = item['lastModifiedUser'];

        return Card(
          child: MaterialButton(
            onPressed: () {
              Navigation.addRoute(
                context,
                SearchResult(
                  serialNo: serialNo,
                  itemName: itemName,
                  acceptDate: acceptDate,
                  expiryDate: expiryDate,
                  locationCode: locationCode,
                  piece: piece,
                  lastModifiedTime: lastModifiedTime,
                  lastModifiedUser: lastModifiedUser,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5, bottom: 2),
              child: ListTile(
                title: SizedBox(height: 20, width: 200, child: Text(itemName)),
                trailing: Text(
                  serialNo,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration formFieldDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color.fromARGB(255, 148, 146, 146)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(0, 129, 129, 129),
        ),
      ),
      hintText: 'Ara',
      contentPadding: const EdgeInsets.all(5.0),
    );
  }
}
