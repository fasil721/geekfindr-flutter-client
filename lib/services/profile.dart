import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:geek_findr/models/user_profile_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final box = Boxes.getInstance();
final controller = Get.find<AppController>();
Future<UserProfileModel?> getUserProfileData() async {
  Future.delayed(const Duration(milliseconds: 500));
  final user = box.get("user");
  const url = "$prodUrl/api/v1/profiles/my-profile/";
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    if (response.statusCode == 200) {
      final jsonData =
          Map<String, dynamic>.from(json.decode(response.body) as Map);
      final userData = UserProfileModel.fromJson(jsonData);
      return userData;
    }
    if (response.statusCode == 422) {
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
    // } catch (e) {
    //   Fluttertoast.showToast(msg: e.toString());
  }
  return null;
}

Future<void> updateUserProfileData(Map<String, dynamic> body) async {
  final user = box.get("user");
  const url = "$prodUrl/api/v1/profiles/my-profile";
  try {
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${user!.token}",
        "Content-Type": "application/json"
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      controller.update(["prof"]);
      Get.back();
    }
    if (response.statusCode == 422) {
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

Future<Iterable<UserProfileModel>> searchUsers({
  required String text,
  String role = "",
}) async {
  final user = box.get("user");
  final url = "$prodUrl/api/v1/profiles?searchUserName=$text&searchRole=$role";
  final client = http.Client();
  try {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${user!.token}",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      final userData = jsonData.map(
        (e) => UserProfileModel.fromJson(
          Map<String, dynamic>.from(e as Map),
        ),
      );

      return userData;
    }
    if (response.statusCode == 422) {
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
  } finally {
    client.close();
  }
  return [];
}
// final TextEditingController _controller = TextEditingController();
// final Debounce _debounce = Debounce(Duration(milliseconds: 400));

// @override
// void dispose() {
//   _controller.dispose();
//   _debounce.dispose();
//   super.dispose();
// }

// @override
// Widget build(BuildContext context) {
//   return TextField(
//     controller: _controller,
//     onChanged: (String value) {
//       _debounce((){
//         print('Value is $value');
//       });
//     },
//   );
// }
