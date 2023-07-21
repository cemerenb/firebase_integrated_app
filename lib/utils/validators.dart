// ignore: unused_import
import 'dart:developer';

import 'package:pirim_depo/utils/text.dart';

class Validators {
  static String? emailValidator(String? mail) {
    String mailErrorMessage = invalidEmail;
    if (mail == null) {
      return mailErrorMessage;
    }

    if (mail.isEmpty) {
      return mailErrorMessage;
    }

    if (!mail.contains('@')) {
      return mailErrorMessage;
    }

    final splittedMail = mail.split('@');

    if (splittedMail.length != 2) {
      return mailErrorMessage;
    }

    final rightPart = splittedMail[1];

    if (!rightPart.contains('.')) {
      return mailErrorMessage;
    }

    return null;
  }

  static String? usernameValidator(String? username) {
    String invalidUsernameMessage = invalidUserName;
    if (username == null) {
      return invalidUsernameMessage;
    }

    if (username.isEmpty) {
      return invalidUsernameMessage;
    }

    if (username.contains(' ')) {
      return invalidUsernameMessage;
    }

    return null;
  }

  static String? nameValidator(String? username) {
    String invalidUsernameMessage = invalidName;
    if (username == null) {
      return invalidUsernameMessage;
    }

    if (username.isEmpty) {
      return invalidUsernameMessage;
    }

    return null;
  }

  static bool specialCharactersPresent(String value) {
    List<String> specialChars = [
      '!',
      '-',
      '@',
      '#',
      '\$',
      '%',
      '^',
      '&',
      '*',
      '(',
      ')',
      '_',
      '=',
      '.',
      ',',
      '/',
      '>',
      '<',
    ];

    for (var char in specialChars) {
      if (value.contains(char)) {
        return true;
      }
    }

    return false;
  }

  static bool numericsPresent(String value) {
    final numericRegex = RegExp(r'[0-9,\b]');
    return numericRegex.hasMatch(value);
  }

  static bool uppercasePresent(String value) {
    final upperCaseRegex = RegExp(r'[A-Z,\b]');
    return upperCaseRegex.hasMatch(value);
  }

  static bool minLengthCorrect(String value, int length) {
    return value.length >= length;
  }
}
