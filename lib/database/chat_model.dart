import 'package:geek_findr/database/lastmessge_model.dart';
import 'package:geek_findr/database/participant_model.dart';
import 'package:hive/hive.dart';
part 'chat_model.g.dart';

@HiveType(typeId: 2)
class MyChatList {
  @HiveField(0)
  List<Participant>? participants;
  @HiveField(1)
  bool? isRoom;
  @HiveField(2)
  String? roomName;
  @HiveField(3)
  DateTime? createdAt;
  @HiveField(4)
  DateTime? updatedAt;
  @HiveField(5)
  String? id;
  @HiveField(6)
  LastMessage? lastMessage;
  @HiveField(7)
  List<LastMessage> unreadMessageList = [];

  MyChatList({
    this.participants,
    this.isRoom,
    this.roomName,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.lastMessage,
  });

  factory MyChatList.fromJson(Map<String, dynamic> json) => MyChatList(
        participants: List<Participant>.from(
          (json["participants"] as List).map(
            (x) => Participant.fromJson(Map<String, String>.from(x as Map)),
          ),
        ),
        isRoom: json["isRoom"] as bool,
        roomName: json["roomName"] as String? ?? "",
        createdAt: DateTime.parse(json["createdAt"] as String),
        updatedAt: DateTime.parse(json["updatedAt"] as String),
        lastMessage: json["lastMessage"] == null
            ? null
            : LastMessage.fromJson(
                Map<String, dynamic>.from(json["lastMessage"] as Map),
              ),
        id: json["id"] as String,
      );
}
