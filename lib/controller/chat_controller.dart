import 'package:geek_findr/constants.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/models/chat_models.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatController extends GetxController {
  late io.Socket socket;
  List<MyChatList> myChatList = [];
  bool isMyChatListLoading = true;

  void connectSocket() {
    final currentUser = Boxes.getCurrentUser();
    // print(currentUser.email);
    const path = '/api/v1/chats/socket.io';
    socket = io.io(prodUrl, <String, dynamic>{
      "path": path,
      'transports': ['websocket'],
      "auth": {"token": currentUser.token},
      'autoConnect': false,
    });
    socket.connect();
    // socket.onConnect((data) {
    //   print('connected ${socket.id}');
    //   final auth = Map<String, String>.from(socket.auth as Map);
    //   print(auth["token"] == currentUser.token);
    //   // if (auth["token"] != currentUser.token) {
    //   //   // socket.disconnect().connect();
    //   //   controller.update(["home"]);
    //   // }
    // });
    // socket.onDisconnect((data) => print('disconnected'));
    // socket.onError((data) => print('error : $data'));
    // socket.on("message", (value) => print(value));
  }

  Future<void> fetchMyChats() async {
    myChatList = (await chatServices.getMyChats())!;
    isMyChatListLoading = false;
    update(["chatList"]);
  }
}
