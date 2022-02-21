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

  Owner? owner;

  factory LikedUsers.fromJson(Map<String, dynamic> json) => LikedUsers(
        owner: Owner.fromJson(Map<String, String>.from(json["owner"] as Map)),
      );

  Map<String, dynamic> toJson() => {
        "owner": owner!.toJson(),
      };
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
  String? createdAt;
  String? updatedAt;
  String? projectName;

  ImageModel({
    this.projectName,
    this.mediaType,
    this.owner,
    this.isProject,
    this.mediaUrl,
    this.description,
    this.likeCount,
    this.isOrganization,
    this.id,
    this.commentCount,
    this.createdAt,
    this.teamJoinRequestCount,
    this.updatedAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        mediaType: json["mediaType"] as String,
        owner: Owner.fromJson(Map<String, String>.from(json["owner"] as Map)),
        isProject: json["isProject"] as bool,
        teamJoinRequestCount: json["teamJoinRequestCount"] as int,
        mediaUrl: json["mediaURL"] as String,
        description: json["description"] as String,
        commentCount: json["commentCount"] as int,
        likeCount: json["likeCount"] as int,
        isOrganization: json["isOrganization"] as bool,
        createdAt: json["createdAt"] as String,
        updatedAt: json["updatedAt"] as String,
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
