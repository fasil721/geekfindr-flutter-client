// ignore_for_file: avoid_print, unused_element

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geek_findr/constants.dart';
import 'package:geek_findr/database/box_instance.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

List<String> urlList = [
  "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2VsZmllJTIwZ2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
  "https://images.unsplash.com/photo-1543486958-d783bfbf7f8e?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2VsZmllfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80",
  "https://image.winudf.com/v2/image1/Y29tLmdvbGRkZXguaGRzZWxmaWVjYW1lcmFfc2NyZWVuXzNfMTU1Mjg3ODE0N18wOTA/screen-3.jpg?fakeurl=1&type=.jpg",
  "https://images.unsplash.com/photo-1598966739654-5e9a252d8c32?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjN8fHNlbGZpZXxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
  "https://ak.picdn.net/shutterstock/videos/17533732/thumb/1.jpg",
];

class Animation7 extends StatefulWidget {
  @override
  _Animation7State createState() => _Animation7State();
}

class _Animation7State extends State<Animation7> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double opacityLevel = 1.0;

  bool _instagramView = false;

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  void _changeOpacityInstagram({required int index}) {
    setState(() =>
        opacityLevelInsta[index] = opacityLevelInsta[index] == 0 ? 1.0 : 0.0);
  }

  List<double> opacityLevelInsta =
      List.generate(urlList.length, (index) => 1.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Animation 7",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {
              setState(() {
                _instagramView = !_instagramView;
              });
            },
            icon: Icon(Icons.swap_horizontal_circle_outlined),
          )
        ],
      ),
      body: _instagramView
          ? _buildInstagramView()
          : Center(
              child: AnimatedOpacity(
                opacity: opacityLevel,
                duration: const Duration(seconds: 2),
                child: GestureDetector(
                  onTap: _changeOpacity,
                  child: flutterLogo(),
                ),
              ),
            ),
    );
  }

  Widget flutterLogo() => const FlutterLogo(
        size: 200,
      );

  Widget _buildInstagramView() {
    double size = 130;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          urlList.length,
          (index) => Container(
            margin:
                EdgeInsets.only(top: 10, left: index == 0 ? 10 : 0, right: 10),
            width: size,
            height: size,
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: opacityLevelInsta[index],
                  duration: const Duration(seconds: 1),
                  child: AnimatedBuilder(
                    animation: _controller,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.purple],
                        ),
                      ),
                    ),
                    builder: (BuildContext context, Widget? child) {
                      return Transform.rotate(
                        angle: _controller.value * 2.0 * math.pi,
                        child: child,
                      );
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _changeOpacityInstagram(index: index);
                  },
                  child: Center(
                    child: CircleAvatar(
                      radius: size * 0.44,
                      backgroundImage: NetworkImage(urlList[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

late io.Socket socket;
void callChat() {
  socket = io.io(
    'http://localhost:3000',
    io.OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM
        .disableAutoConnect() // disable auto-connection
        .setExtraHeaders({'foo': 'bar'}) // optional
        .build(),
  );
  socket.connect();
  print(socket.connected);
  socket.onConnect((_) => print('connected'));
  socket.onDisconnect((_) => print('disconnected'));
}

void connectToServer() {
  try {
    // Configure socket transports must be sepecified
    socket = io.io('http://127.0.0.1:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to websocket
    socket.connect();

    // Handle socket events
    socket.on('connect', (_) => print('connect: ${socket.id}'));
    socket.on('location', handleLocationListen);
    socket.on('typing', handleTyping);
    socket.on('message', handleMessage);
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
    print(socket.connected);
  } catch (e) {
    print(e.toString());
  }
}

// Send Location to Server
void sendLocation(Map<String, dynamic> data) {
  socket.emit("location", data);
}

// Listen to Location updates of connected usersfrom server
void handleLocationListen(dynamic data) {
  print(data);
}

// Send update of user's typing status
void sendTyping({required bool typing}) {
  socket.emit("typing", {
    "id": socket.id,
    "typing": typing,
  });
}

// Listen to update of typing status from connected users
void handleTyping(dynamic data) {
  print(data);
}

// Send a Message to the server
void sendMessage(String message) {
  socket.emit(
    "message",
    {
      "id": socket.id,
      "message": message, // Message to be sent
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    },
  );
}

// Listen to all message events from connected users
void handleMessage(dynamic data) {
  print(data);
}

void initsocket(String id) {
  final currentUser = Boxes.getCurrentUser();
  const path = '/api/v1/chats/socket.io';
  final socket = io.io(prodUrl, <String, dynamic>{
    "path": path,
    'transports': ['websocket'],
    "auth": {"token": currentUser.token}
  });
  socket.connect();
  socket.onConnect((_) => print('connected ${socket.id}'));
  socket.onDisconnect((_) => print('disconnected'));
  socket.onError((_) => print('error : $_'));
  // print("connected : ${socket.connected}");
  // print("disconnected : ${socket.disconnected}");
  socket.emit("join_conversation", {"conversationId": id});
  print(id);
  socket.emit("message", {"message": "hai"});
  socket.on("message", (data) => print(data));
}

void connectSocketio() {
  final currentUser = Boxes.getCurrentUser();
  const uri = '/api/v1/chats/socket.io';
  final socket = io.io(
    prodUrl,
    io.OptionBuilder()
        .setPath(uri)
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setExtraHeaders({
          "auth": {"token": currentUser.token}
        })
        .build(),
  );
  socket.connect();
  socket.onConnect((_) => print('connected'));
  socket.onDisconnect((_) => print('disconnected'));
  socket.onError((_) => print('error : $_'));
  print("connected : ${socket.connected}");
  print("disconnected : ${socket.disconnected}");
}
