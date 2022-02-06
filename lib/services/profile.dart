
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:geek_findr/models/user_profile_model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

final box = Hive.box('usermodel');
Future<UserProfileModel?> getUserProfileData() async {
  await Future.delayed(const Duration(seconds: 2));
  final user = box.get("user") as UserModel;
  const url = "$prodUrl/api/v1/profiles/my-profile/";
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user.token}"},
    );
    if (response.statusCode == 200) {
      final jsonData =
          Map<String, dynamic>.from(json.decode(response.body) as Map);
      final userData = UserProfileModel.fromJson(jsonData);
      return userData;
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}

Future<void> updateProfileData(Map<String, dynamic> body) async {
  final user = box.get("user") as UserModel;
  const url = "$prodUrl/api/v1/profiles/my-profile";

  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${user.token}",
        "Content-Type": "application/json"
      },
      body: json.encode(body),
    );
    if (response.statusCode == 422) {
      final errorJson = json.decode(response.body) as Map;
      final err = ErrorModel.fromJson(errorJson.cast());
      for (final element in err.errors!) {
        Fluttertoast.showToast(msg: element.message!);
      }
    }
    if (response.statusCode == 200) {
      Get.back();
    }
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
}
