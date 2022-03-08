// ignore_for_file: avoid_print

import 'package:geek_findr/contants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

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

void connectSocket() {
  const uri = '$prodUrl/api/v1/chats';
  socket = io.io(
    uri,
    io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );
  socket.connect();
  socket.onConnect((_) => print('connected'));
  socket.onDisconnect((_) => print('disconnected'));
  print(socket.connected);
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

void initsocket() {
  io.Socket socket;
  print('Connecting to chat service');
  socket = io.io('https://ff847a462e9a.ngrok.io', <String, dynamic>{
    '"transports': ['websocket'],
    'autoConnect': false,
  });
  socket.connect();
  print(socket.connected);
}
