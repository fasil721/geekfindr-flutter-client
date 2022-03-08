import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geek_findr/components/chat_list.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/functions.dart';
import 'package:geek_findr/services/profileServices/profile_model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late ChatController _chatController;
  final focusNode = FocusNode();
  @override
  void initState() {
    _chatController = Get.put(ChatController());
    // focusNode.addListener(() {
    //   if (focusNode.hasFocus) {
    //     istexting = true;
    //     _chatController.update(["search"]);
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    textFactor = textfactorCustomize(MediaQuery.textScaleFactorOf(context));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // connectSocket();
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
                SizedBox(height: height * 0.015),
                ListView.builder(
                  itemCount: chatUsers.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUsersList(
                      text: chatUsers[index].text,
                      secondaryText: chatUsers[index].secondaryText,
                      image: chatUsers[index].image,
                      time: chatUsers[index].time,
                      isMessageRead: index == 0 || index == 2 || index == 3,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
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
              onSuggestionSelected: (UserDetials? user) {},
            ),
          );
        },
      );

  List<ChatUsers> chatUsers = [
    ChatUsers(
      text: "Jane Russel",
      secondaryText: "Awesome Setup",
      image: "assets/images/logo.png",
      time: "Now",
    ),
    ChatUsers(
      text: "Glady's Murphy",
      secondaryText: "That's Great",
      image: "assets/images/logo.png",
      time: "Yesterday",
    ),
    ChatUsers(
      text: "Jorge Henry",
      secondaryText: "Hey where are you?",
      image: "assets/images/logo.png",
      time: "31 Mar",
    ),
    ChatUsers(
      text: "Philip Fox",
      secondaryText: "Busy! Call me in 20 mins",
      image: "assets/images/logo.png",
      time: "28 Mar",
    ),
    ChatUsers(
      text: "Debra Hawkins",
      secondaryText: "Thankyou, It's awesome",
      image: "assets/images/logo.png",
      time: "23 Mar",
    ),
    ChatUsers(
      text: "Jacob Pena",
      secondaryText: "will update you in evening",
      image: "assets/images/logo.png",
      time: "17 Mar",
    ),
    ChatUsers(
      text: "Andrey Jones",
      secondaryText: "Can you please share the file?",
      image: "assets/images/logo.png",
      time: "24 Feb",
    ),
    ChatUsers(
      text: "John Wick",
      secondaryText: "How are you?",
      image: "assets/images/logo.png",
      time: "18 Feb",
    ),
  ];
}

class ChatUsers {
  String text;
  String secondaryText;
  String image;
  String time;
  ChatUsers({
    required this.text,
    required this.secondaryText,
    required this.image,
    required this.time,
  });
}
