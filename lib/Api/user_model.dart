class UserModel {
  UserModel({
    this.email,
    this.password,
    this.avatar,
    this.id,
    this.token,
    this.username,
  });

  String? email;
  String? password;
  String? avatar;
  String? id;
  String? token;
  String? username;

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
