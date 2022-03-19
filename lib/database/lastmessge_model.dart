import 'package:hive/hive.dart';
part 'lastmessge_model.g.dart';

@HiveType(typeId: 4)
class LastMessage {
  LastMessage({
    this.senderId,
    this.message,
    this.conversationId,
    this.createdAt,
  });
  @HiveField(0)
  String? senderId;
  @HiveField(1)
  String? message;
  @HiveField(2)
  String? conversationId;
  @HiveField(3)
  DateTime? createdAt;

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        senderId: json["senderId"] as String,
        message: json["message"] as String,
        conversationId: json["conversationId"] as String,
        createdAt: DateTime.parse(json["createdAt"] as String),
      );
}
