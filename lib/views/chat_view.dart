import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/services/chatServices/chat_class_models.dart';
import 'package:geek_findr/test.dart';
import 'package:shimmer/shimmer.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;
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
  const ChatDetailPage({required this.user, required this.id});
  final Participant user;
  final String id;
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // List<ChatMessage> chatMessage = [
  //   ChatMessage(message: "Hi John", type: MessageType.receiver),
  //   ChatMessage(message: "Hope you are doin good", type: MessageType.receiver),
  //   ChatMessage(
  //     message: "Hello Jane, I'm good what about you",
  //     type: MessageType.sender,
  //   ),
  //   ChatMessage(
  //     message: "I'm fine, Working from home",
  //     type: MessageType.receiver,
  //   ),
  //   ChatMessage(message: "Oh! Nice. Same here man", type: MessageType.sender),
  // ];

  // List<SendMenuItems> menuItems = [
  //   SendMenuItems(
  //     text: "Photos & Videos",
  //     icons: Icons.image,
  //     color: Colors.amber,
  //   ),
  //   SendMenuItems(
  //     text: "Document",
  //     icons: Icons.insert_drive_file,
  //     color: Colors.blue,
  //   ),
  //   SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
  //   SendMenuItems(
  //     text: "Location",
  //     icons: Icons.location_on,
  //     color: Colors.green,
  //   ),
  //   SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  // ];

  // void showModal() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return Container(
  //         height: MediaQuery.of(context).size.height / 2,
  //         color: const Color(0xff737373),
  //         child: Container(
  //           decoration: const BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.only(
  //               topRight: Radius.circular(20),
  //               topLeft: Radius.circular(20),
  //             ),
  //           ),
  //           child: Column(
  //             children: <Widget>[
  //               const SizedBox(
  //                 height: 16,
  //               ),
  //               Center(
  //                 child: Container(
  //                   height: 4,
  //                   width: 50,
  //                   color: Colors.grey.shade200,
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               ListView.builder(
  //                 itemCount: menuItems.length,
  //                 shrinkWrap: true,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 itemBuilder: (context, index) {
  //                   return Container(
  //                     padding: const EdgeInsets.only(top: 10, bottom: 10),
  //                     child: ListTile(
  //                       leading: Container(
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(30),
  //                           color: menuItems[index].color.shade50,
  //                         ),
  //                         height: 50,
  //                         width: 50,
  //                         child: Icon(
  //                           menuItems[index].icons,
  //                           size: 20,
  //                           color: menuItems[index].color.shade400,
  //                         ),
  //                       ),
  //                       title: Text(menuItems[index].text),
  //                     ),
  //                   );
  //                 },
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChatDetailPageAppBar(user: widget.user),
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
                    onTap: () {
                      // showModal();
                    },
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
                  initsocket(widget.id);
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
// class SendMenuItems {
//   String text;
//   IconData icons;
//   MaterialColor color;
//   SendMenuItems({required this.text, required this.icons, required this.color});
// }

// class ChatBubble extends StatefulWidget {
//   const ChatBubble({required this.chatMessage});
//   final ChatMessage chatMessage;
//   @override
//   _ChatBubbleState createState() => _ChatBubbleState();
// }

// class _ChatBubbleState extends State<ChatBubble> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//       child: Align(
//         alignment: widget.chatMessage.type == MessageType.receiver
//             ? Alignment.topLeft
//             : Alignment.topRight,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: widget.chatMessage.type == MessageType.receiver
//                 ? Colors.white
//                 : Colors.grey.shade200,
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Text(widget.chatMessage.message),
//         ),
//       ),
//     );
//   }
// }

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ChatDetailPageAppBar({required this.user});
  final Participant user;
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
              Icon(
                Icons.more_vert,
                color: Colors.grey.shade700,
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
