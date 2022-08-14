import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String STH_WENT_WRONG = "Something went wrong, please try again.";

const List<String> ITEMS = <String>[
  "Chair",
  "Table",
  "Dish",
  "Bowl",
  "Balloon",
];

ButtonStyle authSignInBtnStyle() {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(CupertinoColors.systemRed),
    foregroundColor: MaterialStateProperty.all(CupertinoColors.white),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
    alignment: Alignment.center,
  );
}

InputDecoration authTextInputDecoration(
    String label, IconData suffixIcon, String? prefix) {
  return InputDecoration(
    prefixText: prefix ?? "",
    contentPadding: const EdgeInsets.all(20.0),
    fillColor: CupertinoColors.systemGrey4,
    filled: true,
    prefixIcon: Icon(suffixIcon),
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: textFieldBorder(),
    focusedBorder: textFieldBorder(),
    errorBorder: textFieldBorder(),
  );
}

OutlineInputBorder textFieldBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(30.0),
  );
}
