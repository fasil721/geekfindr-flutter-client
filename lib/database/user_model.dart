import 'package:hive_flutter/hive_flutter.dart';
part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  String? email;

  @HiveField(1)
  String? password;

  @HiveField(2)
  String? avatar;

  @HiveField(3)
  String? id;

  @HiveField(4)
  String? token;

  @HiveField(5)
  String? username;

  UserModel({
    this.email,
    this.username,
    this.avatar,
    this.id,
    this.token,
  });

  factory UserModel.fromJson(Map<String, String> json) => UserModel(
        email: json["email"],
        username: json["username"],
        avatar: json["avatar"],
        id: json["id"],
        token: json["token"],
      );

  Map<String, String> toJsonSignIn() => {
        "email": email!,
        "password": password!,
      };

  Map<String, String> toJsonSignUp() => {
        "email": email!,
        "username": username!,
        "password": password!,
      };
}
