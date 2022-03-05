class UserProfileModel {
  UserProfileModel({
    this.email,
    this.username,
    this.avatar,
    this.bio,
    this.organizations,
    this.followersCount,
    this.followingCount,
    this.experience,
    this.education,
    this.works,
    this.skills,
    this.socials,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.id,
  });
  int? followersCount;
  int? followingCount;
  String? role;
  String? email;
  String? username;
  String? avatar;
  List<String>? organizations;
  String? experience;
  List<Map<String, String>>? education;
  List<dynamic>? works;
  List<String>? skills;
  List<Map<String, String>>? socials;
  String? createdAt;
  String? updatedAt;
  String? bio;
  String? id;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        email: json["email"] as String,
        username: json["username"] as String,
        avatar: json["avatar"] as String,
        id: json["id"] as String,
        organizations: List<String>.from(
          (json["organizations"] as List).map((x) => x),
        ),
        followersCount: json["followersCount"] as int,
        followingCount: json["followingCount"] as int,
        experience: json["experience"] as String,
        role: json["role"] as String,
        bio: json["bio"] as String,
        socials: List<Map<String, String>>.from(
          (json["socials"] as List)
              .map((x) => Map<String, String>.from(x as Map)),
        ),
        education: List<Map<String, String>>.from(
          (json["education"] as List)
              .map((x) => Map<String, String>.from(x as Map)),
        ),
        skills: List<String>.from((json["skills"] as List).map((x) => x)),
        works: List<dynamic>.from((json["works"] as List).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "organizations": List<String>.from(organizations!.map((x) => x)),
        "experience": experience,
        "skills": skills,
        "education": List<Map<String, String>>.from(education!.cast()),
        "socials": List<Map<String, String>>.from(socials!.cast()),
        "role": role,
      };
}

class UserDetials {
  UserDetials({
    this.username,
    this.avatar,
    this.role,
    this.id,
  });

  String? username;
  String? avatar;
  String? role;
  String? id;

  factory UserDetials.fromJson(Map<String, String> json) => UserDetials(
        username: json["username"],
        avatar: json["avatar"],
        role: json["role"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "avatar": avatar,
        "role": role,
        "id": id,
      };
}
