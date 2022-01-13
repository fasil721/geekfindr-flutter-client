import 'package:flutter/material.dart';
import 'package:geek_findr/theme.dart';
import 'package:geek_findr/views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: LoginPage(),
    );
  }
}
