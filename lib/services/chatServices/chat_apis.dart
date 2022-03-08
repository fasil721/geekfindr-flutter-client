import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:geek_findr/services/chatServices/chat_class_models.dart';
import 'package:http/http.dart' as http;

class ChatServices {
  Future<List<MyChatList>?> getMyChats() async {
    const url = "$prodUrl/api/v1/chats/my-conversations";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${currentUser.token}",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final datas = jsonData
            .map(
              (e) => MyChatList.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
        return datas;
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
