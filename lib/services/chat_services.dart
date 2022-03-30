import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/database/chat_model.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/models/chat_models.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatServices {
  Future<List<MyChatList>?> getMyChats() async {
    final currentUser = Boxes.getCurrentUser();
    const url = "$prodUrl/api/v1/chats/my-conversations";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${currentUser.token}",
        },
      );
    
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
      } 
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
      // } catch (e) {
      //   Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  Future<MyChatList?> create1to1Conversation({
    required String userId,
  }) async {
    final currentUser = Boxes.getCurrentUser();
    const url = "$prodUrl/api/v1/chats/conversations";
    final body = {
      "isRoom": false,
      "participants": [userId]
    };
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
        Get.back();
        final jsonData = json.decode(response.body);
        final datas = MyChatList.fromJson(
          Map<String, dynamic>.from(jsonData as Map),
        );
        return datas;
      } else if (response.statusCode == 422 || response.statusCode == 400) {
        final errorJson = json.decode(response.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        for (final element in err.errors!) {
          Fluttertoast.showToast(msg: element.message!);
        }
      } 
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
      // } catch (e) {
      //   Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  Future<List<ChatMessage>> getMyChatMessages({
    required String conversationId,
  }) async {
    final currentUser = Boxes.getCurrentUser();
    final url = "$prodUrl/api/v1/chats/conversations/$conversationId/messages";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${currentUser.token}",
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final datas = jsonData
            .map(
              (e) => ChatMessage.fromJson(
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

  Future<MyChatList?> createRoomConversation({
    required List<String> userIds,
    required String roomName,
  }) async {
    final currentUser = Boxes.getCurrentUser();
    const url = "$prodUrl/api/v1/chats/conversations";
    final body = {
      "isRoom": true,
      "participants": userIds,
      "roomName": roomName,
    };
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
        Get.back();
        final jsonData = json.decode(response.body);
        final datas = MyChatList.fromJson(
          Map<String, dynamic>.from(jsonData as Map),
        );
        return datas;
      } else if (response.statusCode == 422 || response.statusCode == 400) {
        final errorJson = json.decode(response.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        for (final element in err.errors!) {
          Fluttertoast.showToast(msg: element.message!);
        }
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

  Future<void> addMemberToRoom({
    required String memberId,
    required String convId,
  }) async {
    final currentUser = Boxes.getCurrentUser();
    final url = "$prodUrl/api/v1/chats/conversations/$convId/participants";
    final body = {"memberId": memberId};
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${currentUser.token}",
          "Content-Type": "application/json",
        },
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        chatController.update(["chatPage"]);
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
}
