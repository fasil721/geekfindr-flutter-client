class UserProfileModel {
  UserProfileModel({
    this.email,
    this.username,
    this.avatar,
    this.organizations,
    this.followers,
    this.following,
    this.experience,
    this.education,
    this.works,
    this.skills,
    this.socials,
    this.createdAt,
    this.updatedAt,
    this.bio,
    this.id,
  });

  String? email;
  String? username;
  String? avatar;
  List<String>? organizations;
  List<dynamic>? followers;
  List<dynamic>? following;
  List<dynamic>? experience;
  List<dynamic>? education;
  List<dynamic>? works;
  List<String>? skills;
  List<dynamic>? socials;
  String? createdAt;
  String? updatedAt;
  String? bio;
  String? id;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        email: json["email"] as String,
        username: json["username"] as String,
        avatar: json["avatar"] as String,
        organizations: List<String>.from(
          (json["organizations"] as List).map((x) => x),
        ),
        followers:
            List<dynamic>.from((json["followers"] as List).map((x) => x)),
        following:
            List<dynamic>.from((json["following"] as List).map((x) => x)),
        experience:
            List<dynamic>.from((json["experience"] as List).map((x) => x)),
        education:
            List<dynamic>.from((json["education"] as List).map((x) => x)),
        works: List<dynamic>.from((json["works"] as List).map((x) => x)),
        skills: List<String>.from((json["skills"] as List).map((x) => x)),
        socials: List<dynamic>.from((json["socials"] as List).map((x) => x)),
        createdAt: json["createdAt"] as String,
        updatedAt: json["updatedAt"] as String,
        bio: json["bio"] as String?,
        id: json["id"] as String,
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "organizations": List<dynamic>.from(organizations!.map((x) => x)),
        "followers": List<dynamic>.from(followers!.map((x) => x)),
        "following": List<dynamic>.from(following!.map((x) => x)),
        "experience": List<dynamic>.from(experience!.map((x) => x)),
        "education": List<dynamic>.from(education!.map((x) => x)),
        "works": List<dynamic>.from(works!.map((x) => x)),
        "skills": List<dynamic>.from(skills!.map((x) => x)),
        "socials": List<dynamic>.from(socials!.map((x) => x)),
        "bio": bio,
        "id": id,
      };
}
