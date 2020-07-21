import 'package:flutter/material.dart';

const kGreenColor = Color(0xFF00B894);

const kTextFieldDecoration  = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: kGreenColor, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      BorderSide(color: kGreenColor, width: 2.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
);

const kCasesTextHeader = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold
);

const kCasesTextBody = TextStyle(
    fontSize: 20,
);