import 'package:flutter/material.dart';
import 'package:pattern_formatter/date_formatter.dart';
import 'package:pirim_depo/utils/text.dart';
import 'package:pirim_depo/utils/validators.dart';

class AddItemNameTextField extends StatelessWidget {
  const AddItemNameTextField({
    super.key,
    required this.nameController,
  });

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: nameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 148, 146, 146),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(),
          ),
          hintText: itemNameText,
          contentPadding: const EdgeInsets.all(20.0),
        ),
      ),
    );
  }
}

class AddItemExpiryDateTextField extends StatelessWidget {
  const AddItemExpiryDateTextField({
    super.key,
    required this.expiryController,
    required this.acceptController,
  });

  final TextEditingController expiryController;
  final TextEditingController acceptController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              keyboardType: TextInputType.datetime,
              controller: expiryController,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                DateInputFormatter(),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(),
                ),
                hintText: expiryDateText,
                contentPadding: const EdgeInsets.all(20.0),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: TextField(
              controller: acceptController,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                DateInputFormatter(),
              ],
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(),
                ),
                hintText: acceptDateText,
                contentPadding: const EdgeInsets.all(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateAccountPageUsernameTextField extends StatelessWidget {
  const CreateAccountPageUsernameTextField({
    super.key,
    required TextEditingController user,
  }) : _user = user;

  final TextEditingController _user;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _user,
      validator: (value) => Validators.usernameValidator(value),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 148, 146, 146),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        hintText: userNameText,
        contentPadding: const EdgeInsets.all(20.0),
      ),
    );
  }
}

class CreateAccountNameTextField extends StatelessWidget {
  const CreateAccountNameTextField({
    super.key,
    required TextEditingController name,
  }) : _name = name;

  final TextEditingController _name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _name,
      validator: (value) => Validators.nameValidator(value),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 148, 146, 146),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        hintText: nameSurname,
        contentPadding: const EdgeInsets.all(20.0),
      ),
    );
  }
}
