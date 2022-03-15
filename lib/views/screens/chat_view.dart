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
import 'package:loading_indicator/loading_indicator.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({required this.item});
  final MyChatList item;
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final textController = TextEditingController();
  final scrollcontroller = ScrollController();
  bool isScrolling = false;
  late double width;
  late double height;
  late double textFactor;
  bool isLoading = true;
  List<Message> messeges = [];
  List<Participant> otherUsers = [];

  @override
  void initState() {
    joinConversation();
    fetchMesseges();
    findParticipants();
    // listenMessages();
    super.initState();
    scrollcontroller.addListener(listenScrolling);
  }

  void listenScrolling() {
    final position = scrollcontroller.position;
    if (position.pixels > 100) {
      isScrolling = true;
      chatController.update(["backToBottom"]);
    } else {
      isScrolling = false;
      chatController.update(["backToBottom"]);
    }
  }

  void joinConversation() {
    chatController.socket
        .emit("join_conversation", {"conversationId": widget.item.id});
  }

  void sendMessage() {
    chatController.socket.emit("message", {"message": textController.text});
    textController.clear();
  }

  Future<void> fetchMesseges() async {
    final currentUser = Boxes.getCurrentUser();
    final datas = await chatServices.getMyChatMessages(
      conversationId: widget.item.id!,
    );
    final data = datas.map(
      (e) {
        final isSentByMe = e.senderId == currentUser.id;
        return Message(
          userId: e.senderId!,
          isSentByMe: isSentByMe,
          text: e.message!,
          date: e.updatedAt!.toLocal(),
        );
      },
    ).toList();
    messeges = data;
    isLoading = false;
    // if (datas.isNotEmpty) {
    //   print(datas.last.message);
    //   print(datas.length);
    //   // print(datas.first.createdAt!.toLocal());
    //   // print(datas.first.createdAt!.toUtc());
    // }
    chatController.update(["messeges"]);
  }

  // void listenMessages() {
  //   final currentUser = Boxes.getCurrentUser();
  //   chatController.socket.on("message", (value) {
  //     final data = ListenMessage.fromJson(
  //       Map<String, dynamic>.from(value as Map),
  //     );
  //     final isSentByMe = data.userId == currentUser.id;
  //     final _messege = Message(
  //       userId: data.userId!,
  //       text: data.message!,
  //       date: data.time!.toLocal(),
  //       isSentByMe: isSentByMe,
  //     );
  //     messeges.add(_messege);
  //     chatController.update(["messeges"]);
  //   });
  // }

  void findParticipants() {
    for (final element in widget.item.participants!) {
      otherUsers.add(element);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    textFactor = textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    // if (messeges.isNotEmpty) {
    //   print(messeges.last.text);
    //   print(messeges.length);
    //   // print(datas.first.createdAt!.toLocal());
    //   // print(datas.first.createdAt!.toUtc());
    // }
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: ChatDetailPageAppBar(
        item: widget.item,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GetBuilder<ChatController>(
                    id: "messeges",
                    builder: (controller) => Stack(
                      children: [
                        if (!isLoading)
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: messeges.isNotEmpty
                                ? GroupedListView<Message, DateTime>(
                                    controller: scrollcontroller,
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
                                      final diff =
                                          (today.difference(msg.date).inHours /
                                                  24)
                                              .round();
                                      late String text;
                                      if (diff == 0) {
                                        text = "Today";
                                      } else if (diff == 1) {
                                        text = "Yesterday";
                                      } else {
                                        text =
                                            DateFormat.yMMMd().format(msg.date);
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
                                    itemBuilder: (context, msg) =>
                                        buildChatBubble(msg),
                                  )
                                : Center(
                                    child: Text(
                                      "0 messages",
                                      style: GoogleFonts.roboto(
                                        fontSize: textFactor * 13,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        color: grey,
                                      ),
                                    ),
                                  ),
                          )
                        else
                          _loadingIndicator()
                      ],
                    ),
                  ),
                  GetBuilder<ChatController>(
                    id: "backToBottom",
                    builder: (controller) => Visibility(
                      visible: isScrolling,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              scrollcontroller.animateTo(
                                0,
                                duration: const Duration(milliseconds: 750),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.keyboard_double_arrow_down_rounded,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
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
                    splashRadius: 25,
                    onPressed: () {
                      // print(DateFormat.jm().format(DateTime.now()));
                      // if (textController.text.isNotEmpty) {
                      //   sendMessage();
                      // }
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

  Widget _loadingIndicator() => const Center(
        child: SizedBox(
          height: 100,
          child: LoadingIndicator(
            indicatorType: Indicator.ballClipRotateMultiple,
            colors: [
              grey,
            ],
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.transparent,
          ),
        ),
      );

  Widget buildChatBubble(Message message) {
    final isSentByMe = message.isSentByMe;
    final user =
        otherUsers.firstWhere((element) => element.id == message.userId);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!message.isSentByMe)
                buildCircleGravatar(user.avatar!, width * 0.07),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  maxWidth: width * 0.6,
                ),
                decoration: BoxDecoration(
                  color: !isSentByMe ? primaryColor : white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isSentByMe ? 12 : 0),
                    bottomRight: Radius.circular(isSentByMe ? 0 : 12),
                  ),
                ),
                child: Text(
                  message.text,
                  style: GoogleFonts.roboto(
                    fontSize: textFactor * 13,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    color: !isSentByMe ? Colors.white : Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment:
                  isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isSentByMe)
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
                    chatController.update(["chatPage"]);
                    Get.back();
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