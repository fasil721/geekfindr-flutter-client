// ignore_for_file: avoid_print

import 'package:geek_findr/constants.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/models/chat_models.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatController extends GetxController {
  late io.Socket socket;
  List<MyChatList>? myChatList = [];
  List<MyChatList> results = [];
  bool isMyChatListLoading = true;

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
      for (int i = 0; i < results.length; i++) {
        if (results[i].id == data.convId) {
          final lastmessage = LastMessage();
          lastmessage.conversationId = data.convId;
          lastmessage.createdAt = data.time;
          lastmessage.senderId = data.userId;
          lastmessage.message = data.message;
          results[i].lastMessage = lastmessage;
          results[i].unreadMessageList!.add(lastmessage);
        }
      }
      update(["chatList", "navCount"]);
    });
  }

  Future<void> fetchMyChats() async {
    myChatList = await chatServices.getMyChats();
    isMyChatListLoading = false;
    update(["chatList"]);
  }

  int findUnreadNotificationCount() {
    int count = 0;
    for (int i = 0; i < results.length; i++) {
      if (results[i].unreadMessageList!.isNotEmpty) {
        count += results[i].unreadMessageList!.length;
      }
    }
    return count;
  }

  // void unreadMessageSetup() {
  //   chatController.unreadMessageList = [];
  //   for (int i = 0; i < results.length; i++) {
  //     chatController.unreadMessageList.add([]);
  //   }
  // }
}
