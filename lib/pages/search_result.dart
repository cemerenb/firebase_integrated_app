import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchResult extends StatefulWidget {
  late String itemName = '';
  late String serialNo = '';
  late String expiryDate = '';
  late String acceptDate = '';
  late String piece = '';
  late String locationCode = '';
  late String lastModifiedTime = '';
  late String lastModifiedUser = '';

  SearchResult(
      {super.key,
      required this.serialNo,
      required this.itemName,
      required this.expiryDate,
      required this.acceptDate,
      required this.piece,
      required this.locationCode,
      required this.lastModifiedTime,
      required this.lastModifiedUser});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemName),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              searchResultItem(context, 'Seri No', widget.serialNo),
              searchResultItem(
                  context, 'Son Kullanma Tarihi', widget.expiryDate),
              searchResultItem(context, 'Kabul Tarihi', widget.acceptDate),
              searchResultItem(context, 'Adet', widget.piece),
              searchResultItem(context, 'Lokasyon Kodu', widget.locationCode),
              searchResultItem(context, 'Son Değişiklik Yapan Kullanıcı',
                  widget.lastModifiedUser),
              searchResultItem(
                  context, 'Son Değişiklik Tarihi', widget.lastModifiedTime),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox searchResultItem(BuildContext context, data, text) {
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
                border: Border.all(width: 1, color: Colors.black)),
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
          )
        ],
      ),
    );
  }
}
