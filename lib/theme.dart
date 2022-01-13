import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class AppColor {
  static Color textColor = const Color(0xff9C9C9D);
  static Color textBlackColor = Colors.black.withOpacity(.8);
  static Color textColorDark = const Color(0xffffffff);

  static Color buttonColor = const Color(0xffB954FE);
  static Color iconColor = Colors.grey.withOpacity(.9);
  static Color bodyColor = const Color(0xffffffff);
  static Color bodyColorDark = const Color(0xff0E0E0F);

  static Color buttonBackgroundColor = const Color(0xffF7F7F7);
  static Color buttonBackgroundColorDark = const Color(0xff121212);
}

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static ThemeData light = lightTheme;
  // static ThemeData dark = darkTheme;
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: AppColor.iconColor,
  scaffoldBackgroundColor: AppColor.bodyColor,
  hintColor: AppColor.textColor,
  primaryColorLight: AppColor.textBlackColor,
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.black.withOpacity(0.89),
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
  ),
  // buttonTheme: ButtonThemeData(
  //   textTheme: ButtonTextTheme.accent,
  //   buttonColor: AppColor.buttonColor,
  // ),
);

// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   backgroundColor: AppColor.bodyColorDark,
//   scaffoldBackgroundColor: AppColor.bodyColorDark,
//   hintColor: AppColor.textColor,
//   primaryColorLight: AppColor.buttonBackgroundColorDark,
//   textTheme: const TextTheme(
//     headline1: TextStyle(
//       color: Colors.white,
//       fontSize: 40,
//       fontWeight: FontWeight.bold,
//     ),
//   ),
//   buttonTheme: ButtonThemeData(
//     buttonColor: AppColor.buttonColor,
//     textTheme: ButtonTextTheme.primary,
//   ),
// );
