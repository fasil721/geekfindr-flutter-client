import 'package:geek_findr/models/profile_model.dart';

class Owner {
  Owner({
    this.username,
    this.avatar,
    this.id,
  });

  String? username;
  String? avatar;
  String? id;

  factory Owner.fromJson(Map<String, String> json) => Owner(
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

class LikedUsers {
  LikedUsers({
    this.owner,
  });

  UserDetials? owner;

  factory LikedUsers.fromJson(Map<String, dynamic> json) => LikedUsers(
        owner: UserDetials.fromJson(
          Map<String, String>.from(json["owner"] as Map),
        ),
      );

  Map<String, dynamic> toJson() => {"owner": owner!.toJson()};
}

class CommentedUsers {
  CommentedUsers({
    this.comment,
    this.owner,
  });

  String? comment;
  Owner? owner;

  factory CommentedUsers.fromJson(Map<String, dynamic> json) => CommentedUsers(
        comment: json["comment"] as String,
        owner: Owner.fromJson(Map<String, String>.from(json["owner"] as Map)),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "owner": owner!.toJson(),
      };
}

class Signedurl {
  Signedurl({
    this.key,
    this.url,
  });

  String? key;
  String? url;

  factory Signedurl.fromJson(Map<String, String> json) => Signedurl(
        key: json["key"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "url": url,
      };
}

class ImageModel {
  int? teamJoinRequestCount;
  String? mediaType;
  Owner? owner;
  bool? isProject;
  String? mediaUrl;
  String? description;
  int? likeCount;
  int? commentCount;
  String? id;
  bool? isOrganization;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? projectName;
  List<Join>? teamJoinRequests;

  ImageModel({
    this.mediaType,
    this.owner,
    this.isProject,
    this.projectName,
    this.mediaUrl,
    this.description,
    this.likeCount,
    this.commentCount,
    this.teamJoinRequestCount,
    this.isOrganization,
    this.teamJoinRequests,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        mediaType: json["mediaType"] as String,
        owner: Owner.fromJson(Map<String, String>.from(json["owner"] as Map)),
        isProject: json["isProject"] as bool,
        projectName:
            json["projectName"] == null ? "" : json["projectName"] as String,
        teamJoinRequestCount: json["teamJoinRequestCount"] as int,
        teamJoinRequests: List<Join>.from(
          (json["teamJoinRequests"] as List)
              .map((x) => Join.fromJson(Map<String, String>.from(x as Map))),
        ),
        mediaUrl: json["mediaURL"] as String,
        description: json["description"] as String,
        commentCount: json["commentCount"] as int,
        likeCount: json["likeCount"] as int,
        isOrganization: json["isOrganization"] as bool,
        createdAt: DateTime.parse(json["createdAt"] as String),
        updatedAt: DateTime.parse(json["updatedAt"] as String),
        id: json["id"] as String,
      );

  Map<String, dynamic> toJson() => {
        "mediaType": mediaType,
        "isProject": isProject,
        "mediaURL": mediaUrl,
        "description": description,
        "isOrganization": isOrganization,
        "projectName": projectName,
      };
}

class Join {
  Join({
    this.owner,
  });

  String? owner;

  factory Join.fromJson(Map<String, String> json) => Join(
        owner: json["owner"],
      );
}

enum PostType { allPosts, posts, projects }
