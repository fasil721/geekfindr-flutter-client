import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/chat_controller.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/database/chat_model.dart';
import 'package:geek_findr/database/participant_model.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/models/profile_model.dart';
import 'package:geek_findr/views/screens/chat_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final searchController1 = TextEditingController();
  final searchController2 = TextEditingController();
  final titleTextController = TextEditingController();

  late double textFactor;
  bool istexting = false;
  late double height;
  late double width;
  List<UserDetials> selectedMembers = [];

  void searchUser(List<MyChatList> datas) {
    final currentUser = Boxes.getCurrentUser();
    List<MyChatList> lists = [];
    if (searchController1.text.isEmpty) {
      lists = datas.toList();
    } else {
      //  results = [];
      for (final i in datas) {
        final isRoom = i.isRoom == true;
        if (isRoom) {
          final s = i.roomName!.toLowerCase().contains(
                searchController1.text.toLowerCase(),
              );
          if (s) {
            lists.add(i);
          }
        } else {
          for (final j in i.participants!) {
            if (j.id != currentUser.id) {
              final s = j.username!.toLowerCase().contains(
                    searchController1.text.toLowerCase(),
                  );
              if (s) {
                lists.add(i);
              }
            }
          }
        }
      }
    }
    lists.sort((a, b) {
      if (a.lastMessage != null && b.lastMessage != null) {
        return a.lastMessage!.createdAt!.compareTo(b.lastMessage!.createdAt!);
      }
      return datas.length - 1;
    });
    chatController.results = lists.reversed.toList();
  }

  bool checkUserExistInMyChat(String userId) {
    final currentUser = Boxes.getCurrentUser();
    final List<Participant> chatUsers = [];
    final my1to1List = chatController.myChatList
        .where((element) => element.isRoom == false)
        .toList();

    for (final e in my1to1List) {
      final user = e.participants!
          .where((element) => element.id != currentUser.id)
          .first;
      chatUsers.add(user);
    }
    final isNotExit =
        chatUsers.where((element) => element.id == userId).isEmpty;
    return isNotExit;
  }

  void checkUser(UserDetials user) {
    final isEmpty = selectedMembers
        .where(
          (element) => element.id == user.id,
        )
        .isEmpty;
    if (isEmpty) {
      selectedMembers.add(user);
      searchController2.clear();
      chatController.update(["selected"]);
    } else {
      Fluttertoast.showToast(msg: "You already added");
    }
  }

  @override
  void initState() {
    // chatController.fetchMyChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    textFactor = textfactorCustomize(MediaQuery.textScaleFactorOf(context));

    return Scaffold(
    
      body: SafeArea(
        child: GetBuilder<ChatController>(
          id: "chatPage",
          builder: (controller) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Chats",
                      style: GoogleFonts.roboto(
                        fontSize: textFactor * 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.dialog(_buildOptionDialoge()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        height: height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: secondaryColor,
                        ),
                        child: Ink(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const Icon(
                                Icons.add,
                                color: primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                "New",
                                style: GoogleFonts.roboto(
                                  fontSize: textFactor * 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.015),
              buildSearchField(),
              SizedBox(height: height * 0.02),
              Expanded(
                child: GetBuilder<ChatController>(
                  id: "chatList",
                  builder: (controller) {
                    searchUser(chatController.myChatList);
                    return chatController.isMyChatListLoading
                        ? _buildLoadingScreen()
                        : chatController.results.isNotEmpty
                            ? ListView.builder(
                                itemCount: chatController.results.length,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (
                                  BuildContext context,
                                  int index,
                                ) =>
                                    buildUsersTile(
                                  chatController.results[index],
                                ),
                              )
                            : Center(
                                child: Text(
                                  "0 Chat users",
                                  style: GoogleFonts.roboto(),
                                ),
                              );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          itemCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: white,
            period: const Duration(milliseconds: 1000),
            child: Container(
              height: height * 0.06,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
              ),
            ),
          ),
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(height: height * 0.015),
        ),
      );

  Widget buildUsersTile(MyChatList item) {
    final isRoom = item.isRoom!;
    final user = findMy1to1chatUser(item);
    String lastMessage = '';
    String lastMessageTime = '';
    if (item.lastMessage != null) {
      lastMessage = item.lastMessage!.message!;
      lastMessageTime =
          DateFormat.jm().format(item.lastMessage!.createdAt!.toLocal());
    }

    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        await Get.to(() => ChatDetailPage(item: item));
        istexting = false;
        searchController1.clear();
        chatController.update(["search"]);
      },
      child: Ink(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: height * 0.01),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
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
                    SizedBox(width: width * 0.03),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              isRoom ? item.roomName! : user.username!,
                              style: GoogleFonts.recursive(
                                fontSize: 16,
                                color: black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Visibility(
                              visible: lastMessage.isNotEmpty,
                              child: Text(
                                lastMessage,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: item.unreadMessageList.isNotEmpty
                                      ? black
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: item.unreadMessageList.isNotEmpty,
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 10,
                      child: Text(
                        '${item.unreadMessageList.length}',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    lastMessageTime,
                    style: GoogleFonts.roboto(
                      fontSize: 11,
                      color: black,
                      fontWeight: FontWeight.w600,
                      // letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField() => GetBuilder<ChatController>(
        id: "search",
        builder: (controller) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: height * 0.06,
          width: width,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: TextField(
            onTap: () {
              istexting = true;
              controller.update(["search"]);
            },
            onChanged: (val) => controller.update(["chatList"]),
            controller: searchController1,
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
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: primaryColor,
                  ),
                  onPressed: () async {
                    searchController1.clear();
                    istexting = false;
                    FocusScope.of(context).unfocus();
                    controller.update(["search", "chatList"]);
                  },
                ),
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: GoogleFonts.roboto(
                fontSize: textFactor * 15,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );

  Widget _buildOptionDialoge() {
    bool isRoom = false;
    selectedMembers = [];
    titleTextController.clear();
    return GetBuilder<ChatController>(
      id: "newConv",
      builder: (controller) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Material(
              color: white,
              borderRadius: BorderRadius.circular(30),
              child: Column(
                children: [
                  Visibility(
                    visible: !isRoom,
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              isRoom = true;
                              controller.update(["newConv"]);
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
                                    "Create a room chat",
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
                  SizedBox(height: height * 0.01),
                  buildSearchDialoge(isRoom: isRoom),
                  Visibility(
                    visible: isRoom,
                    child: TextField(
                      controller: titleTextController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Room name",
                        hintStyle:
                            GoogleFonts.roboto(fontSize: textFactor * 15),
                        filled: true,
                        fillColor: Colors.transparent,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isRoom,
                    child: GetBuilder<ChatController>(
                      id: "selected",
                      builder: (_) => buildInputChips(selectedMembers),
                    ),
                  ),
                  Visibility(
                    visible: isRoom,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            isRoom = false;
                            controller.update(["newConv"]);
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.roboto(
                              color: black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(3),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (titleTextController.text.isNotEmpty ||
                                selectedMembers.isNotEmpty) {
                              final userIds =
                                  selectedMembers.map((e) => e.id!).toList();
                              final data =
                                  await chatServices.createRoomConversation(
                                roomName: titleTextController.text,
                                userIds: userIds,
                              );
                              if (data != null) {
                                Get.to(() => ChatDetailPage(item: data));
                                chatController.myChatList.add(data);
                                controller.update(["chatList"]);
                              } else {
                                Fluttertoast.showToast(
                                  msg: "This room already exists",
                                );
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: "users and room name's are required",
                              );
                            }
                          },
                          child: Text(
                            "Create",
                            style: GoogleFonts.roboto(
                              color: white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5)
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchDialoge({required bool isRoom}) {
    final currentUser = Boxes.getCurrentUser();
    searchController2.clear();
    istexting = false;
    return GetBuilder<ChatController>(
      id: "search2",
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
              controller.update(["search2"]);
            },
            controller: searchController2,
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
                    searchController2.clear();
                    istexting = false;
                    FocusScope.of(context).unfocus();
                    controller.update(["search2"]);
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
              if (isRoom) {
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
              } else {
                final isNotExist = checkUserExistInMyChat(user.id!);
                if (isNotExist) {
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
              }
            }
            return const SizedBox();
          },
          loadingBuilder: (context) => const SizedBox(),
          noItemsFoundBuilder: (context) => SizedBox(
            height: 60,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  isRoom
                      ? "0 Result found"
                      : "0 Result found maybe You already chatting with this user",
                  style: GoogleFonts.roboto(),
                ),
              ),
            ),
          ),
          onSuggestionSelected: (UserDetials? user) async {
            searchController2.clear();
            if (isRoom) {
              checkUser(user!);
            } else {
              istexting = false;
              final data =
                  await chatServices.create1to1Conversation(userId: user!.id!);
              await Get.to(() => ChatDetailPage(item: data!));
              chatController.myChatList.add(data!);
            }
            controller.update(["chatList"]);
          },
        ),
      ),
    );
  }

  Widget buildInputChips(List<UserDetials> members) => Wrap(
        spacing: 10,
        children: members
            .map(
              (e) => InputChip(
                avatar: CircleAvatar(
                  backgroundImage: NetworkImage(e.avatar!),
                ),
                label: Text(e.username!),
                labelStyle: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                onDeleted: () {
                  selectedMembers.remove(e);
                  chatController.update(["selected"]);
                },
              ),
            )
            .toList(),
      );
}
