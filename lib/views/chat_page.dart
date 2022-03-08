// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geek_findr/components/chat_list.dart';
import 'package:geek_findr/contants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  _ChatPageState createState() => _ChatPageState();
}


class _ChatPageState extends State<ChatPage> {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("------------");
          // connectSocket();
          //  callChat();
          final data = await chatServices.getMyChats();
          final a = data!.first.participants!
              .firstWhere((element) => element.id != currentUser.id);
          print(a.toJson());
          // final io.Socket socket =
          //     io.io('$prodUrl/api/v1/chats', <String, dynamic>{
          //   "transports": ["websocket"],
          //   "autoConnect": true,
          // });
          // print(socket.connected);
          // socket.connect();
          // socket.onConnect((_) => print('connect'));
          // socket.onDisconnect((_) => print('disconnect'));
          // print(socket.connected);
          print("-----------");
        },
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      "Chats",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 2,
                        bottom: 2,
                      ),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.add,
                            color: Colors.pink,
                            size: 20,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "New",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  // contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade100),
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
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
    );
  }
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
