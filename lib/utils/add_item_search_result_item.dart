import 'package:flutter/material.dart';

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
