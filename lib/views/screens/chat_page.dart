import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/chat_controller.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/models/chat_models.dart';
import 'package:geek_findr/models/profile_model.dart';
import 'package:geek_findr/views/screens/chat_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final searchController = TextEditingController();
  late double textFactor;
  bool istexting = false;
  late double height;
  late double width;
  // List<MyChatList> myList = [];
  // late ChatController _chatController;

  @override
  void initState() {
    // _chatController =
    Get.put(ChatController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    textFactor = textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //    connectSocket();
          // connectToServer();
          //  callChat();
          // initsocket();
          // final data = await chatServices.getMyChats();
          // final a = data!.first.participants!
          //     .firstWhere((element) => element.id != currentUser.id);
          // print(a.toJson());
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        height: height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: secondaryColor,
                        ),
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
                      )
                    ],
                  ),
                ),
                SizedBox(height: height * 0.015),
                buildSearchField(),
                SizedBox(height: height * 0.02),
                FutureBuilder<List<MyChatList>?>(
                  future: chatServices.getMyChats(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingScreen();
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data != null) {
                        // final chatUsers = findMy1to1chatUsers(snapshot.data!);
                        final datas = snapshot.data!;
                        return ListView.separated(
                          itemCount: datas.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) =>
                              buildUsersTile(
                            datas[index],
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(height: height * 0.02),
                        );
                      }
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() => ListView.separated(
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
      );

  Widget buildUsersTile(MyChatList item) {
    final isRoom = item.isRoom!;
    final user = findMy1to1chatUser(item);
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ChatDetailPage(
            item: item,
          ),
        );
      },
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
                SizedBox(
                  width: width * 0.03,
                ),
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
                        // Text(
                        //   isRoom ? items[index].roomName! : user.username!,
                        //   style: GoogleFonts.roboto(
                        //     fontSize: 14,
                        //     color: Colors.grey.shade500,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Text(
            "Now",
            style: TextStyle(
              fontSize: 12,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchField() => GetBuilder<ChatController>(
        id: "search",
        builder: (controller) {
          return Container(
            height: height * 0.06,
            width: width,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: TypeAheadField<UserDetials?>(
              getImmediateSuggestions: true,
              hideSuggestionsOnKeyboardHide: false,
              debounceDuration: const Duration(milliseconds: 500),
              textFieldConfiguration: TextFieldConfiguration(
                onTap: () {
                  istexting = true;
                  controller.update(["search"]);
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
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: primaryColor,
                      ),
                      onPressed: () async {
                        searchController.clear();
                        istexting = false;
                        SystemChannels.textInput.invokeMethod("TextInput.hide");
                        controller.update(["search"]);
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
              suggestionsCallback: (value) {
                if (value.isNotEmpty) {
                  return profileServices.searchUsers(text: value);
                }
                return [];
              },
              itemBuilder: (context, UserDetials? suggestion) {
                final user = suggestion!;
                return ListTile(
                  textColor: secondaryColor,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      user.avatar!,
                      width: 30,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.blue,
                        height: 130,
                        width: 130,
                      ),
                    ),
                  ),
                  title: Text(
                    user.username!,
                    style: GoogleFonts.roboto(color: Colors.black),
                  ),
                );
              },
              noItemsFoundBuilder: (context) => const SizedBox(),
              onSuggestionSelected: (UserDetials? user) {
                istexting = false;
                searchController.clear();
                controller.update(["search"]);
              },
            ),
          );
        },
      );
}
