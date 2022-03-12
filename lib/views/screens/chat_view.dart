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
  late double width;
  late double textFactor;
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
      print(data.time!.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    textFactor = textfactorCustomize(MediaQuery.textScaleFactorOf(context));

    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: ChatDetailPageAppBar(
        item: widget.item,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
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
                                letterSpacing: 1.2,
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
                      ),
                      child: TextField(
                        controller: textController,
                        textInputAction: TextInputAction.newline,
                        maxLines: null,
                        minLines: 1,
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
                      // print(DateFormat.jm().format(DateTime.now()));
                      if (textController.text.isNotEmpty) {
                        sendMessage();
                      }
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      size: 25,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 3,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: message.isSentByMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (!message.isSentByMe)
                  buildCircleGravatar(currentUser.avatar!, width * 0.07),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  constraints: BoxConstraints(
                    maxWidth: width * 0.6,
                  ),
                  decoration: BoxDecoration(
                    color: !message.isSentByMe ? primaryColor : white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isSentByMe ? 12 : 0),
                      bottomRight: Radius.circular(message.isSentByMe ? 0 : 12),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.roboto(
                      fontSize: textFactor * 13,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      color:
                          !message.isSentByMe ? Colors.white : Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: message.isSentByMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!message.isSentByMe)
                    const SizedBox(
                      width: 40,
                    ),
                  const Icon(
                    Icons.done_all,
                    size: 18,
                    color: grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    DateFormat.jm().format(message.date),
                    style: GoogleFonts.roboto(
                      color: const Color(0xffAEABC9),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  )
                ],
              ),
            )
          ],
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
                  splashRadius: 25,
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
                  buildCircleGravatar(user.avatar!, width * 0.1),
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

 
