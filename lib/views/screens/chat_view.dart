import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/chat_controller.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/models/chat_models.dart';
import 'package:geek_findr/models/profile_model.dart';
import 'package:geek_findr/views/screens/users_profile_page.dart';
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
    listenMessages();
    super.initState();
    scrollcontroller.addListener(listenScrolling);
  }

  @override
  void dispose() {
    chatController.fetchMyChats();
    super.dispose();
  }

  void listenMessages() {
    print("value");
    final currentUser = Boxes.getCurrentUser();
    chatController.socket.on("message", (value) {
      final data = ListenMessage.fromJson(
        Map<String, dynamic>.from(value as Map),
      );
      if (data.convId == widget.item.id) {
        final isSentByMe = data.userId == currentUser.id;
        final _messege = Message(
          userId: data.userId!,
          text: data.message!,
          date: data.time!.toLocal(),
          isSentByMe: isSentByMe,
        );
        messeges.add(_messege);
        chatController.update(["messeges"]);
      }
    });
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
    if (textController.text.isNotEmpty) {
      chatController.socket.emit("message", {
        "message": textController.text,
        "conversationId": widget.item.id,
      });
      textController.clear();
    }
  }

  Future<void> fetchMesseges() async {
    final currentUser = Boxes.getCurrentUser();
    final datas =
        await chatServices.getMyChatMessages(conversationId: widget.item.id!);
    messeges = datas.map(
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

    isLoading = false;
    chatController.update(["messeges"]);
  }

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
    // }
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: ChatDetailPageAppBar(
        item: widget.item,
        height: height,
        width: width,
        textFactor: textFactor,
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
                                            padding: const EdgeInsets.all(3),
                                            child: Text(
                                              text,
                                              style: GoogleFonts.roboto(
                                                color: white,
                                                fontSize: textFactor * 12,
                                                letterSpacing: 1,
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
                  SizedBox(width: 16, height: height * 0),
                  IconButton(
                    splashRadius: 25,
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.send_rounded,
                      size: 25,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 3),
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
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSentByMe)
            buildCircleGravatar(user.avatar!, width * 0.07),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            constraints: BoxConstraints(
              maxWidth: width * 0.8,
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    // right: 60,
                    top: 5,
                    bottom: 5,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: message.text,
                          style: GoogleFonts.roboto(
                            fontSize: textFactor * 14,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                            color:
                                !isSentByMe ? Colors.white : Colors.grey[800],
                          ),
                        ),
                        TextSpan(
                          text: "...........",
                          style: GoogleFonts.roboto(
                            fontSize: textFactor * 14,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                            color: isSentByMe ? Colors.white : primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    DateFormat.jm().format(message.date),
                    style: GoogleFonts.roboto(
                      color: isSentByMe
                          ? const Color(0xffAEABC9)
                          : white.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChatDetailPageAppBar({
    required this.item,
    required this.height,
    required this.width,
    required this.textFactor,
  });
  final MyChatList item;
  final double height;
  final double width;
  final double textFactor;

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  IconButton(
                    splashRadius: 20,
                    onPressed: Get.back,
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: black.withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 2),
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
                    buildCircleGravatar(user.avatar!, width * 0.09),
                  const SizedBox(width: 12),
                  Text(
                    isRoom ? item.roomName! : user.username!,
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Visibility(
                visible: item.isRoom!,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: IconButton(
                      splashRadius: 22,
                      onPressed: () {
                        usersDialoge(context);
                      },
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: black.withOpacity(0.6),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void usersDialoge(BuildContext context) {
    bool isCreating = false;
    final userList = item.participants!.map((e) => e).toList();
    Get.dialog(
      GetBuilder<ChatController>(
        id: "roomInfo",
        builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                height: height / 2,
                child: Material(
                  color: secondaryColor,
                  child: Column(
                    children: [
                      Visibility(
                        visible: !isCreating,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  isCreating = true;
                                  controller.update(["roomInfo"]);
                                },
                                child: Ink(
                                  child: Row(
                                    children: [
                                      SizedBox(width: width * 0.005),
                                      const Icon(
                                        Icons.add,
                                        size: 25,
                                        color: primaryColor,
                                      ),
                                      Text(
                                        "Add members",
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isCreating,
                        child: buildSearchDialoge(context, userList),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: userList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  () => OtherUserProfile(
                                    userId: userList[index].id!,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    buildCircleGravatar(
                                      userList[index].avatar!,
                                      width * 0.09,
                                    ),
                                    SizedBox(width: width * 0.05),
                                    Text(
                                      userList[index].username!,
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500,
                                        fontSize: textFactor * 17,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget buildSearchDialoge(BuildContext context, List<Participant> usersList) {
    final currentUser = Boxes.getCurrentUser();
    final searchController = TextEditingController();
    bool istexting = false;
    return GetBuilder<ChatController>(
      id: "addMemberSearch",
      builder: (controller) => Container(
        height: height * 0.06,
        width: width,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: TypeAheadField<UserDetials?>(
          getImmediateSuggestions: true,
          direction: AxisDirection.up,
          hideSuggestionsOnKeyboardHide: false,
          debounceDuration: const Duration(milliseconds: 500),
          textFieldConfiguration: TextFieldConfiguration(
            onTap: () {
              istexting = true;
              controller.update(["addMemberSearch"]);
            },
            controller: searchController,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              focusColor: primaryColor,
              iconColor: primaryColor,
              prefixIcon: const Icon(
                Icons.search,
                color: primaryColor,
              ),
              suffixIcon: Visibility(
                visible: istexting,
                child: IconButton(
                  splashRadius: 20,
                  icon: const Icon(Icons.close, size: 20, color: primaryColor),
                  onPressed: () async {
                    searchController.clear();
                    istexting = false;
                    FocusScope.of(context).unfocus();
                    controller.update(["addMemberSearch"]);
                  },
                ),
              ),
              border: InputBorder.none,
              hintText: "Search and select",
              hintStyle: GoogleFonts.roboto(
                fontSize: textFactor * 15,
                color: Colors.grey,
              ),
            ),
          ),
          suggestionsCallback: (value) {
            if (value.isNotEmpty) {
              return profileServices.searchUsers(text: value);
            }
            return [];
          },
          itemBuilder: (context, UserDetials? suggestion) {
            final user = suggestion!;
            if (user.id != currentUser.id) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    buildCircleGravatar(
                      user.avatar!,
                      width * 0.085,
                    ),
                    SizedBox(width: width * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username!,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: textFactor * 16,
                          ),
                        ),
                        Visibility(
                          visible: user.role!.isNotEmpty,
                          child: Text(
                            user.role!,
                            style: GoogleFonts.roboto(
                              color: grey,
                              fontWeight: FontWeight.w500,
                              fontSize: textFactor * 13,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
            return const SizedBox();
          },
          noItemsFoundBuilder: (context) => SizedBox(
            height: 60,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "0 Result found",
                  style: GoogleFonts.roboto(),
                ),
              ),
            ),
          ),
          onSuggestionSelected: (UserDetials? user) async {
            final participan = Participant();
            participan.avatar = user!.avatar;
            participan.id = user.id;
            participan.username = user.username;
            istexting = false;
            item.participants!.add(participan);
            usersList.add(participan);
            controller.update(["roomInfo"]);
            searchController.clear();
            chatServices.addMemberToRoom(memberId: user.id!, convId: item.id!);
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
