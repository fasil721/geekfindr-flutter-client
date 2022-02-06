class UserProfileModel {
  UserProfileModel({
    this.email,
    this.username,
    this.avatar,
    this.bio,
    this.organizations,
    this.followers,
    this.following,
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
  List<dynamic>? followers;
  List<dynamic>? following;
  String? experience;
  List<dynamic>? education;
  List<dynamic>? works;
  List<String>? skills;
  List<Social>? socials;
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
        followers:
            List<dynamic>.from((json["followers"] as List).map((x) => x)),
        following:
            List<dynamic>.from((json["following"] as List).map((x) => x)),
        followersCount: json["followersCount"] as int,
        followingCount: json["followingCount"] as int,
        experience: json["experience"] as String,
        role: json["role"] as String,
        createdAt: json["createdAt"] as String,
        updatedAt: json["updatedAt"] as String,
        socials: List<Social>.from(
          (json["socials"] as List)
              .map((x) => Social.fromJson(Map<String, String>.from(x as Map))),
        ),
        education:
            List<dynamic>.from((json["education"] as List).map((x) => x)),
        skills: List<String>.from((json["skills"] as List).map((x) => x)),
        works: List<dynamic>.from((json["works"] as List).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "bio": bio,
        "organizations": List<String>.from(organizations!.map((x) => x)),
        "experience": experience,
        "socials":
            List<Map<String, String>>.from(socials!.map((x) => x.toJson())),
        "role": role,
      };
}

class Social {
  Social({
    this.github,
    this.linkedin,
  });

  String? github;
  String? linkedin;

  factory Social.fromJson(Map<String, String> json) => Social(
        github: json["github"],
        linkedin: json["linkedin"],
      );

  Map<String, dynamic> toJson() => {
        "github": github,
        "linkedin": linkedin,
      };
}
