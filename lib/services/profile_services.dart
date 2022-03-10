import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:geek_findr/models/profile_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileServices {
  Future<UserProfileModel?> getUserProfileData() async {
    final currentUser = Boxes.getCurrentUser();
    const url = "$prodUrl/api/v1/profiles/my-profile/";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${currentUser.token}"},
      );
      if (response.statusCode == 200) {
        final jsonData =
            Map<String, dynamic>.from(json.decode(response.body) as Map);
        final userData = UserProfileModel.fromJson(jsonData);
        return userData;
      } else if (response.statusCode == 422) {
        final errorJson = json.decode(response.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        for (final element in err.errors!) {
          Fluttertoast.showToast(msg: element.message!);
        }
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
    return null;
  }

  Future<void> updateUserProfileData(Map<String, dynamic> body) async {
    final currentUser = Boxes.getCurrentUser();
    const url = "$prodUrl/api/v1/profiles/my-profile";
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${currentUser.token}",
          "Content-Type": "application/json"
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        profileController.update(["profileView"]);
        Get.back();
      } else if (response.statusCode == 422) {
        final errorJson = json.decode(response.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        for (final element in err.errors!) {
          Fluttertoast.showToast(msg: element.message!);
        }
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<List<UserDetials>> searchUsers({
    required String text,
    String role = "",
  }) async {
    final currentUser = Boxes.getCurrentUser();
    final url =
        "$prodUrl/api/v1/profiles?searchUserName=$text&searchRole=$role";
    final client = http.Client();
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${currentUser.token}"},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final userData = jsonData
            .map(
              (e) => UserDetials.fromJson(
                Map<String, String>.from(e as Map),
              ),
            )
            .toList();
        return userData;
      } else if (response.statusCode == 422) {
        final errorJson = json.decode(response.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        for (final element in err.errors!) {
          Fluttertoast.showToast(msg: element.message!);
        }
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return [];
  }

  Future<void> followUsers({
    required Map<String, String> body,
  }) async {
    final currentUser = Boxes.getCurrentUser();
    const url = "$prodUrl/api/v1/profiles/following";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${currentUser.token}",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        profileController.update(["profileView", "followers"]);
      } else if (response.statusCode == 422 || response.statusCode == 400) {
        final errorJson = json.decode(response.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        for (final element in err.errors!) {
          Fluttertoast.showToast(msg: element.message!);
        }
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<List<UserDetials>> getUserfollowersAndFollowings({
    required String id,
    required String type,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    String url = "$prodUrl/api/v1/profiles/$id/";
    final currentUser = Boxes.getCurrentUser();
    if (type == "followers") {
      url = url + type;
    } else if (type == "following") {
      url = url + type;
    }
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${currentUser.token}"},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final userData = jsonData
            .map(
              (e) => UserDetials.fromJson(
                Map<String, String>.from(e as Map),
              ),
            )
            .toList();
        return userData;
      } else if (response.statusCode == 422) {
        final errorJson = json.decode(response.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        for (final element in err.errors!) {
          Fluttertoast.showToast(msg: element.message!);
        }
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return [];
  }

  Future<UserProfileModel?> getUserProfilebyId({
    required String id,
  }) async {
    final currentUser = Boxes.getCurrentUser();
    await Future.delayed(const Duration(milliseconds: 500));
    final url = "$prodUrl/api/v1/profiles/$id";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${currentUser.token}"},
      );
      if (response.statusCode == 200) {
        final jsonData =
            Map<String, dynamic>.from(json.decode(response.body) as Map);
        final userData = UserProfileModel.fromJson(jsonData);
        return userData;
      } else if (response.statusCode == 422 || response.statusCode == 400) {
        final errorJson = json.decode(response.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        for (final element in err.errors!) {
          Fluttertoast.showToast(msg: element.message!);
        }
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }
}
