import 'package:hive/hive.dart';
part 'participant_model.g.dart';

@HiveType(typeId: 3)
class Participant {
  Participant({
    this.username,
    this.avatar,
    this.id,
  });
  @HiveField(0)
  String? username;
  @HiveField(1)
  String? avatar;
  @HiveField(2)
  String? id;

  factory Participant.fromJson(Map<String, String> json) => Participant(
        username: json["username"],
        avatar: json["avatar"],
        id: json["id"],
      );
}
