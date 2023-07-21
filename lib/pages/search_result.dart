import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  final String itemName;
  final String serialNo;
  final String expiryDate;
  final String acceptDate;
  final String piece;
  final String locationCode;
  final String lastModifiedTime;
  final String lastModifiedUser;

  const SearchResult({
    super.key,
    required this.serialNo,
    required this.itemName,
    required this.expiryDate,
    required this.acceptDate,
    required this.piece,
    required this.locationCode,
    required this.lastModifiedTime,
    required this.lastModifiedUser,
  });

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.itemName),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                searchResultItem(context, 'Seri No', widget.serialNo),
                searchResultItem(
                    context, 'Son Kullanma Tarihi', widget.expiryDate),
                searchResultItem(context, 'Kabul Tarihi', widget.acceptDate),
                searchResultItem(context, 'Lokasyon Kodu', widget.locationCode),
                searchResultItem(context, 'Son Değişiklik Yapan Kullanıcı',
                    widget.lastModifiedUser),
                searchResultItem(
                    context, 'Son Değişiklik Tarihi', widget.lastModifiedTime),
                searchResultItem(context, 'Adet', widget.piece),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget searchResultItem(BuildContext context, String data, String text) {
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.black),
            ),
            height: 45,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
