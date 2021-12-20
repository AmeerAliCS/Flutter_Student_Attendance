import 'package:flutter/material.dart';

const kColor = Color(0xFF495464);
const gColor = Color(0xFF00ADB5);
const oColor = Color(0xFFDF6265);


const kTextFieldDecoration  = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kColor, width: 2.0),
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