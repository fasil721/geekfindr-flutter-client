import 'package:flutter/material.dart';

const prodUrl = "http://www.geekfindr-dev-app.xyz";
const primaryColor = Color(0xffB954FE);
const secondaryColor = Color(0xffF3F4F7);
const white = Colors.white;
const black = Colors.black;
double textfactorfind(double val) {
  if (val == 0.85) {
    return val + 0.1;
  } else if (val == 1.00) {
    return val;
  } else if (val == 1.15) {
    return val - 0.2;
  } else if (val == 1.3) {
    return val - 0.4;
  } else if (val == 1.45) {
    return val - 0.6;
  } else if (val == 1.6) {
    return val - 0.8;
  } else {
    return val;
  }
}

List<Map> categories = [
  {"name": "Cats", 'iconPath': 'assets/icons/office.png'},
  {'name': 'Dogs', 'iconPath': 'assets/icons/office.png'},
  {'name': 'Bu5i', 'iconPath': 'assets/icons/office.png'},
  {'name': 'Pa5s', 'iconPath': 'assets/icons/office.png'},
];

List<BoxShadow> shadowList = [
  const BoxShadow(
    color: Colors.grey,
    blurRadius: 5,
    offset: Offset(5, 5),
  )
];
