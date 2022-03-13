import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/controller/chat_controller.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/models/chat_models.dart';
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
  List<MyChatList> results = [];

  @override
  void initState() {
    Get.put(ChatController());
    super.initState();
  }

  void searchUser(List<MyChatList> datas) {
    final currentUser = Boxes.getCurrentUser();
    if (searchController.text.isEmpty) {
      results = datas.toList();
    } else {
      results = [];
      for (final i in datas) {
        final isRoom = i.isRoom == true;
        if (isRoom) {
          final s = i.roomName!.toLowerCase().contains(
                searchController.text.toLowerCase(),
              );
          if (s) {
            results.add(i);
          }
        } else {
          for (final j in i.participants!) {
            if (j.id != currentUser.id) {
              final s = j.username!.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  );
              if (s) {
                results.add(i);
              }
            }
          }
        }
      }
    }
  }
  // bool? checkUserExistInMyChat({String? userId}) {
  //   final currentUser = Boxes.getCurrentUser();
  //   final List<Participant> chatUsers = [];
  //   my1to1List = datas.where((element) => element.isRoom == false).toList();
  //   if (userId != null) {
  //     for (final e in my1to1List) {
  //       final user = e.participants!
  //           .where((element) => element.id != currentUser.id)
  //           .first;
  //       chatUsers.add(user);
  //     }
  //     final isNotExit =
  //         chatUsers.where((element) => element.id == userId).isEmpty;
  //     return isNotExit;
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    textFactor = textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Padding(
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
                        final datas = snapshot.data!;
                        return GetBuilder<ChatController>(
                          id: "chatList",
                          builder: (controller) {
                            searchUser(datas);
                            return ListView.builder(
                              reverse: true,
                              itemCount: results.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) =>
                                  buildUsersTile(results[index]),
                            );
                          },
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
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        istexting = false;
        searchController.clear();
        chatController.update(["search"]);
        Get.to(
          () => ChatDetailPage(
            item: item,
          ),
        );
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
        ),
      ),
    );
  }

  Widget buildSearchField() {
    return GetBuilder<ChatController>(
      id: "search",
      builder: (controller) {
        return Container(
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
        );
      },
    );
  }
  // Widget buildSearchField() {
  //   final currentUser = Boxes.getCurrentUser();
  //   return GetBuilder<ChatController>(
  //     id: "search",
  //     builder: (controller) {
  //       return Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 20),
  //         height: height * 0.06,
  //         width: width,
  //         decoration: BoxDecoration(
  //           color: secondaryColor,
  //           borderRadius: BorderRadius.circular(50),
  //         ),
  //         child: TypeAheadField<UserDetials?>(
  //           getImmediateSuggestions: true,
  //           hideSuggestionsOnKeyboardHide: false,
  //           debounceDuration: const Duration(milliseconds: 500),
  //           textFieldConfiguration: TextFieldConfiguration(
  //             onTap: () {
  //               istexting = true;
  //               controller.update(["search"]);
  //             },
  //             controller: searchController,
  //             cursorColor: primaryColor,
  //             decoration: InputDecoration(
  //               focusColor: primaryColor,
  //               iconColor: primaryColor,
  //               prefixIcon: const Icon(
  //                 Icons.search,
  //                 color: primaryColor,
  //               ),
  //               suffixIcon: Visibility(
  //                 visible: istexting,
  //                 child: IconButton(
  //                   splashRadius: 20,
  //                   icon: const Icon(
  //                     Icons.close,
  //                     size: 20,
  //                     color: primaryColor,
  //                   ),
  //                   onPressed: () async {
  //                     searchController.clear();
  //                     istexting = false;
  //                     FocusScope.of(context).requestFocus(FocusNode());
  //                     controller.update(["search"]);
  //                   },
  //                 ),
  //               ),
  //               border: InputBorder.none,
  //               hintText: "Search",
  //               hintStyle: GoogleFonts.roboto(
  //                 fontSize: textFactor * 15,
  //                 color: Colors.grey,
  //               ),
  //             ),
  //           ),
  //           suggestionsCallback: (value) {
  //             if (value.isNotEmpty) {
  //               return profileServices.searchUsers(text: value);
  //             }
  //             return [];
  //           },
  //           itemBuilder: (context, UserDetials? suggestion) {
  //             final user = suggestion!;
  //             if (user.id != currentUser.id) {
  //               return Padding(
  //                 padding: const EdgeInsets.all(10),
  //                 child: Row(
  //                   children: [
  //                     buildCircleGravatar(
  //                       user.avatar!,
  //                       width * 0.085,
  //                     ),
  //                     SizedBox(width: width * 0.04),
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           user.username!,
  //                           style: GoogleFonts.roboto(
  //                             fontWeight: FontWeight.w400,
  //                             fontSize: textFactor * 16,
  //                           ),
  //                         ),
  //                         Visibility(
  //                           visible: user.role!.isNotEmpty,
  //                           child: Text(
  //                             user.role!,
  //                             style: GoogleFonts.roboto(
  //                               color: grey,
  //                               fontWeight: FontWeight.w500,
  //                               fontSize: textFactor * 13,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               );
  //             }
  //             return const SizedBox();
  //           },
  //           noItemsFoundBuilder: (context) => const SizedBox(),
  //           onSuggestionSelected: (UserDetials? user) async {
  //             user = user!;
  //             istexting = false;
  //             searchController.clear();
  //             FocusScope.of(context).requestFocus(FocusNode());
  //             final isNotExist = checkUserExistInMyChat(userId: user.id)!;
  //             print(isNotExist);
  //             if (isNotExist) {
  //               final data = await chatServices.create1to1Conversation(
  //                 userId: user.id!,
  //               );
  //               Get.to(
  //                 () => ChatDetailPage(item: data!),
  //               );
  //             } else {
  //               print(my1to1List.length);
  //               final data = my1to1List.firstWhere(
  //                 (element) {
  //                   final _user = element.participants!
  //                       .firstWhere((ele) => element.id != currentUser.id);
  //                   final isUser = _user.id == user!.id;
  //                   return isUser;
  //                 },
  //               );
  //               Get.to(
  //                 () => ChatDetailPage(item: data),
  //               );
  //             }
  //             controller.update(["search"]);
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
}
