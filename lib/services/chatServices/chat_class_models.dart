class MyChatList {
  MyChatList({
    this.participants,
    this.isRoom,
    this.roomName,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  List<Participant>? participants;
  bool? isRoom;
  String? roomName;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;

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
        id: json["id"] as String,
      );
}

class Participant {
  Participant({
    this.username,
    this.avatar,
    this.id,
  });

  String? username;
  String? avatar;
  String? id;

  factory Participant.fromJson(Map<String, String> json) => Participant(
        username: json["username"],
        avatar: json["avatar"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "avatar": avatar,
        "id": id,
      };
}
