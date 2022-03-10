import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/chat_controller.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/models/chat_models.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({required this.item});
  final MyChatList item;
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final textController = TextEditingController();
  final currentUser = Boxes.getCurrentUser();
  late Socket socket;
  List<Message> messeges = [];
  @override
  void initState() {
    connectSocket();
    fetchMesseges();
    listenMessages();
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
      "auth": {"token": currentUser.token}
    });
    socket.connect();
    socket.onConnect((data) => print('connected ${socket.id}'));
    socket.onDisconnect((data) => print('disconnected'));
    socket.onError((data) => print('error : $data'));
    socket.emit("join_conversation", {"conversationId": widget.item.id});
    // socket.on("message", (data) => print(data));
    print(widget.item.id);
  }

  void sendMessage() {
    socket.emit("message", {"message": textController.text});
    textController.clear();
  }

  Future<void> fetchMesseges() async {
    final datas = await chatServices.getMyChatMessages(
      conversationId: widget.item.id!,
    );
    messeges = datas.map(
      (e) {
        final isSentByMe = e.senderId == currentUser.id;
        return Message(
          isSentByMe: isSentByMe,
          text: e.message!,
          date: e.createdAt!,
        );
      },
    ).toList();
    chatController.update(["messeges"]);
  }

  void listenMessages() {
    socket.on("message", (value) {
      final data = ListenMessage.fromJson(
        Map<String, dynamic>.from(value as Map),
      );
      final isSentByMe = data.userId == currentUser.id;
      final _messege = Message(
        text: data.message!,
        date: data.time!,
        isSentByMe: isSentByMe,
      );
      messeges.add(_messege);
      chatController.update(["messeges"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textFactor =
        textfactorCustomize(MediaQuery.textScaleFactorOf(context));

    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: ChatDetailPageAppBar(
        item: widget.item,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<ChatController>(
                id: "messeges",
                builder: (controller) => GroupedListView<Message, DateTime>(
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  elements: messeges,
                  useStickyGroupSeparators: true,
                  floatingHeader: true,
                  groupBy: (msg) => DateTime(
                    msg.date.year,
                    msg.date.month,
                    msg.date.day,
                  ),
                  groupHeaderBuilder: (msg) {
                    final today = DateTime.now();
                    final diff = today.difference(msg.date).inDays;
                    late String text;
                    if (diff == 0) {
                      text = "Today";
                    } else if (diff == 1) {
                      text = "Yesterday";
                    } else {
                      text = DateFormat.yMMMd().format(msg.date);
                    }
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Card(
                        color: primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            text,
                            style: GoogleFonts.roboto(
                              color: white,
                              fontSize: textFactor * 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemBuilder: (context, msg) {
                    return buildChatBubble(msg);
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 5),
              width: width,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: "Type message...",
                          hintStyle: GoogleFonts.roboto(
                            color: Colors.grey.shade500,
                            fontSize: textFactor * 15,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                    height: height * 0,
                  ),
                  IconButton(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        sendMessage();
                      }
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      size: 30,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChatBubble(Message message) => Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Align(
          alignment:
              !message.isSentByMe ? Alignment.topLeft : Alignment.topRight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.all(16),
            child: Text(message.text),
          ),
        ),
      );
}

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChatDetailPageAppBar({
    required this.item,
  });
  final MyChatList item;
  @override
  Widget build(BuildContext context) {
    final user = findMy1to1chatUser(item);
    final isRoom = item.isRoom!;
    final width = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: Center(
        child: SafeArea(
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
                if (isRoom)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/images/grp icon.png",
                      fit: BoxFit.fitWidth,
                      width: width * 0.1,
                    ),
                  )
                else
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
                  child: Text(
                    isRoom ? item.roomName! : user.username!,
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// class ChatBubble extends StatefulWidget {
//   const ChatBubble({required this.chatMessage});
//   final ChatMessage chatMessage;
//   @override
//   _ChatBubbleState createState() => _ChatBubbleState();
// }


 


// class ChatMessage {
//   String message;
//   MessageType type;
//   ChatMessage({required this.message, required this.type});
// }

// class SendMenuItems {
//   String text;
//   IconData icons;
//   MaterialColor color;
//   SendMenuItems({required this.text, required this.icons, required this.color});
// }

// enum MessageType {
//   sender,
//   receiver,
//}

 
