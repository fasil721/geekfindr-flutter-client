// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/database/chat_model.dart';
import 'package:geek_findr/database/lastmessge_model.dart';
import 'package:geek_findr/models/chat_models.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatController extends GetxController {
  late io.Socket socket;
  List<MyChatList>? myChatList = [];
  List<MyChatList> results = [];
  bool isMyChatListLoading = true;
  String currentChating = "";
  final _box = BoxChat.getInstance();

  void connectSocket() {
    final currentUser = Boxes.getCurrentUser();
    print(currentUser.email);
    const path = '/api/v1/chats/socket.io';
    socket = io.io(prodUrl, <String, dynamic>{
      "path": path,
      'transports': ['websocket'],
      "auth": {"token": currentUser.token},
      'autoConnect': false,
    });
    socket.connect();
    // if (socket.connected == false) {
    // }
    socket.onConnect((data) {
      print('connected ${socket.id}');
      final auth = Map<String, String>.from(socket.auth as Map);
      print(auth["token"] == currentUser.token);
      // if (auth["token"] != currentUser.token) {
      //   // socket.disconnect().connect();
      //   controller.update(["home"]);
      // }
    });
    socket.onDisconnect((data) => print('disconnected'));
    socket.onError((data) => print('error : $data'));
    socket.on("message", (value) {
      print(value);
      final data = ListenMessage.fromJson(
        Map<String, dynamic>.from(value as Map),
      );
      if (currentChating.isEmpty || currentChating != data.convId) {
        if (myChatList != null) {
          for (int i = 0; i < myChatList!.length; i++) {
            if (myChatList![i].id == data.convId) {
              final lastmessage = LastMessage(
                conversationId: data.convId,
                createdAt: data.time,
                senderId: data.userId,
                message: data.message,
              );
              myChatList![i].lastMessage = lastmessage;
              myChatList![i].unreadMessageList.add(lastmessage);
            }
            _box.put("chats", myChatList!);
          }
        }
        update(["chatList", "navCount"]);
      }
    });
  }

  Future<void> updateChatDB() async {
    final box = BoxChat.getInstance();
    final chats = await chatServices.getMyChats();
    await box.put("chats", chats!);
  }

  Future<void> fetchMyChats() async {
    myChatList = await chatServices.getMyChats();
    isMyChatListLoading = false;
    update(["chatList"]);
  }

  int findUnreadNotificationCount() {
    int count = 0;
    for (int i = 0; i < results.length; i++) {
      if (results[i].unreadMessageList.isNotEmpty) {
        count += results[i].unreadMessageList.length;
      }
    }
    return count;
  }

  void markAsRead(MyChatList item) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final index = results.indexOf(item);
      results[index].unreadMessageList = [];
      update(["chatList", "navCount"]);
    });
  }
}
