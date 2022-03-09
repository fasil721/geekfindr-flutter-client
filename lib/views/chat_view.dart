import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/services/chatServices/chat_class_models.dart';
import 'package:geek_findr/test.dart';
import 'package:shimmer/shimmer.dart';

import 'package:socket_io_client/socket_io_client.dart';
// enum MessageType {
//   sender,
//   receiver,
// }
// class ChatMessage {
//   String message;
//   MessageType type;
//   ChatMessage({required this.message, required this.type});
// }

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({required this.user, required this.conversationId});
  final Participant user;
  final String conversationId;
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _currentUser = Boxes.getCurrentUser();
  final textController = TextEditingController();
  late Socket socket;
  @override
  void initState() {
    connectSocket();
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void connectSocket() {
    const path = '/api/v1/chats/socket.io';
    socket = io(prodUrl, <String, dynamic>{
      "path": path,
      'transports': ['websocket'],
      "auth": {"token": _currentUser.token}
    });
    socket.connect();
    socket.onConnect((_) => print('connected ${socket.id}'));
    socket.onDisconnect((_) => print('disconnected ${socket.id}'));
    socket.onError((_) => print('error : $_'));
    socket.emit("join_conversation", {"conversationId": widget.conversationId});
    socket.on("message", (data) => print(data));
    print(widget.conversationId);
  }

  void sendMessage() {
    socket.emit("message", {"message": textController.text});
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailPageAppBar(
          user: widget.user, conversationId: widget.conversationId),
      body: Stack(
        children: <Widget>[
          // ListView.builder(
          //   itemCount: chatMessage.length,
          //   shrinkWrap: true,
          //   padding: const EdgeInsets.only(top: 10, bottom: 10),
          //   physics: const NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index) {
          //     return ChatBubble(
          //       chatMessage: chatMessage[index],
          //     );
          //   },
          // ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              height: 80,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(right: 15, bottom: 15),
              child: FloatingActionButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    sendMessage();
                  }

                  // initsocket(widget.conversationId);
                },
                backgroundColor: Colors.pink,
                elevation: 0,
                child: const Icon(
                  Icons.send,
                  size: 21,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChatDetailPageAppBar(
      {required this.user, required this.conversationId});
  final Participant user;
  final String conversationId;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: user.avatar!,
                  fit: BoxFit.fitWidth,
                  width: width * 0.1,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.3),
                    highlightColor: white,
                    period: const Duration(
                      milliseconds: 1000,
                    ),
                    child: Container(
                      height: width * 0.1,
                      width: width * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      user.username!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  final a = await chatServices.getMyChatMessages(
                    conversationId: conversationId,
                  );
                  print(a!.map((e) => e.message));
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
