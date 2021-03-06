

class ChatMessage {
  ChatMessage({
    this.senderId,
    this.message,
    this.conversationId,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  String? senderId;
  String? message;
  String? conversationId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        senderId: json["senderId"] as String,
        message: json["message"] as String,
        conversationId: json["conversationId"] as String,
        createdAt: DateTime.parse(json["createdAt"] as String),
        updatedAt: DateTime.parse(json["updatedAt"] as String),
        id: json["id"] as String,
      );

  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "message": message,
        "conversationId": conversationId,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "id": id,
      };
}

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;
  final String userId;
  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
    required this.userId,
  });
}

class ListenMessage {
  ListenMessage({
    this.message,
    this.userId,
    this.time,
    this.convId,
  });

  String? message;
  String? userId;
  String? convId;
  DateTime? time;

  factory ListenMessage.fromJson(Map<String, dynamic> json) => ListenMessage(
        message: json["message"] as String,
        userId: json["userId"] as String,
        convId: json["conversationId"] as String,
        time: DateTime.parse(json["time"] as String),
      );
}

class CreateChatModel {
  CreateChatModel({
    this.participants,
    this.messages,
    this.isRoom,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  List<String>? participants;
  List<dynamic>? messages;
  bool? isRoom;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;

  factory CreateChatModel.fromJson(Map<String, dynamic> json) =>
      CreateChatModel(
        participants:
            List<String>.from((json["participants"] as List).map((x) => x)),
        messages: List<dynamic>.from((json["messages"] as List).map((x) => x)),
        isRoom: json["isRoom"] as bool,
        createdAt: DateTime.parse(json["createdAt"] as String),
        updatedAt: DateTime.parse(json["updatedAt"] as String),
        id: json["id"] as String,
      );
}
