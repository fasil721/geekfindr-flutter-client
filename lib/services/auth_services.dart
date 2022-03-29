import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/database/user_model.dart';
import 'package:geek_findr/main.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  final box = Boxes.getInstance();

  Future<void> userSignIn({
    required String email,
    required String password,
  }) async {
    final userModel = UserModel();
    userModel.email = email;
    userModel.password = password;
    try {
      final response = await http.post(
        Uri.parse("$prodUrl/api/v1/users/signin"),
        body: userModel.toJsonSignIn(),
      );
      if (response.statusCode == 200) {
        final jsonData =
            Map<String, String>.from(json.decode(response.body) as Map);
        final user = UserModel.fromJson(jsonData);
        await box.put("user", user);
        await Get.offAll(() => const MyApp());
      } else if (response.statusCode == 400) {
        final errorJson = json.decode(response.body) as Map;
        final error = ErrorModel.fromJson(errorJson.cast());
        Fluttertoast.showToast(msg: error.errors!.first.message!);
      }
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No internet connection");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> userSignUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final userModel = UserModel();
    userModel.username = username;
    userModel.email = email;
    userModel.password = password;

    try {
      final response = await http.post(
        Uri.parse("$prodUrl/api/v1/users/signup/"),
        body: userModel.toJsonSignUp(),
      );
      if (response.statusCode == 201) {
        final jsonData =
            Map<String, String>.from(json.decode(response.body) as Map);
        final user = UserModel.fromJson(jsonData);
        await box.put("user", user);
        await Get.offAll(() => const MyApp());
      } else if (response.statusCode == 400) {
        final errorJson = json.decode(response.body) as Map;
        final error = ErrorModel.fromJson(errorJson.cast());
        Fluttertoast.showToast(msg: error.errors!.first.message!);
      }
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No internet connection");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
