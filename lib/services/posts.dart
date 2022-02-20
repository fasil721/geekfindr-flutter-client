import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final box = Boxes.getInstance();
final controller = Get.find<AppController>();

Future<void> uploadImage({
  required String description,
  required File image,
  required bool isProject,
  String projectName = "",
}) async {
  final user = box.get("user");
  const getUrl =
      "$prodUrl/api/v1/uploads/signed-url?fileType=image&fileSubType=jpg";
  const postUrl = "$prodUrl/api/v1/posts/";
  try {
    final response1 = await http.get(
      Uri.parse(getUrl),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    final jsonData = json.decode(response1.body) as Map;
    final data = Signedurl.fromJson(jsonData.cast());

    final response2 = await http.put(
      Uri.parse(data.url!),
      body: image.readAsBytesSync(),
    );
    if (response2.statusCode == 200) {
      final imageModel = ImageModel();
      imageModel.projectName = projectName;
      imageModel.description = description;
      imageModel.isOrganization = false;
      imageModel.isProject = isProject;
      imageModel.mediaUrl = data.key;
      imageModel.mediaType = "image";

      final response3 = await http.post(
        Uri.parse(postUrl),
        body: json.encode(imageModel.toJson()),
        headers: {
          "Authorization": "Bearer ${user.token}",
          "Content-Type": "application/json"
        },
      );
      print(response3.statusCode);
      if (response3.statusCode == 200) {
        if (projectName.isNotEmpty) {
          Fluttertoast.showToast(
            msg: "New Project Created and Projest post uploaded",
          );
        } else {
          Fluttertoast.showToast(msg: "Post uploaded");
        }
        controller.update(["mypost", "postCount"]);
        Get.back();
      } else if (response3.statusCode == 400 || response3.statusCode == 422) {
        final errorJson = json.decode(response3.body) as Map;
        final err = ErrorModel.fromJson(errorJson.cast());
        for (final element in err.errors!) {
          Fluttertoast.showToast(msg: element.message!);
        }
      } else {
        print(response3.body);
        Fluttertoast.showToast(msg: "Image not uploaded");
      }
    } else {
      Fluttertoast.showToast(msg: "Image not uploaded");
    }
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet");
  } on SocketException {
    Fluttertoast.showToast(msg: "No Internet");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
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

Future<List<ImageModel>> getMyImages(String id) async {
  // await Future.delayed(Duration(seconds: 5));
  final user = box.get("user");
  final url = "$prodUrl/api/v1/posts/by-users/$id";

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      final data = jsonData
          .map((e) => ImageModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      return data;
    } else if (response.statusCode == 422 || response.statusCode == 400) {
      final errorJson = json.decode(response.body) as Map;
      final err = ErrorModel.fromJson(errorJson.cast());
      for (final element in err.errors!) {
        Fluttertoast.showToast(msg: element.message!);
      }
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
    return [];
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet");
  } on SocketException {
    Fluttertoast.showToast(msg: "No Internet");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
  return [];
}

Future<List<ImageModel>> getMyFeeds({String? lastId}) async {
  // await Future.delayed(Duration(seconds: 5));
  final user = box.get("user");
  String url = "$prodUrl/api/v1/posts/my-feed?limit=5";
  if (lastId != null) {
    url = "$prodUrl/api/v1/posts/my-feed?limit=5&lastId=$lastId";
  }
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      final data = jsonData
          .map((e) => ImageModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return data;
    } else if (response.statusCode == 422 || response.statusCode == 400) {
      final errorJson = json.decode(response.body) as Map;
      final err = ErrorModel.fromJson(errorJson.cast());
      for (final element in err.errors!) {
        Fluttertoast.showToast(msg: element.message!);
      }
    } else {
      print(response.statusCode);
      print(response.body);
      Fluttertoast.showToast(msg: "Something went wrong");
    }
    return [];
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet");
  } on SocketException {
    Fluttertoast.showToast(msg: "No Internet");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
  return [];
}

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

Future deleteImage({required String imageId}) async {
  final user = box.get("user");
  final url = "$prodUrl/api/v1/posts/$imageId";

  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Image deleted successfully");
      controller.update(["mypost", "postCount"]);
    } else {
      Fluttertoast.showToast(msg: "Image not deleted successfully");
    }
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on SocketException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
}

Future editImage({required String imageId, required Map body}) async {
  final user = box.get("user");
  final url = "$prodUrl/api/v1/posts/$imageId";

  try {
    final response = await http.patch(
      Uri.parse(url),
      body: json.encode(body),
      headers: {
        "Authorization": "Bearer ${user!.token}",
        "Content-Type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Image edited successfully");
      controller.update(["mypost"]);
      Get.back();
    } else {
      Fluttertoast.showToast(msg: "Image not edited successfully");
    }
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on SocketException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
}

Future<void> postLike({required String imageId}) async {
  final user = box.get("user");
  final url = "$prodUrl/api/v1/posts/$imageId/likes";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    if (response.statusCode == 200) {
      controller.update(["likes"]);
    } else if (response.statusCode == 422 || response.statusCode == 400) {
      final errorJson = json.decode(response.body) as Map;
      final err = ErrorModel.fromJson(errorJson.cast());
      for (final element in err.errors!) {
        Fluttertoast.showToast(msg: element.message!);
      }
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on SocketException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
}

Future<List<LikedUsers>?> getLikedUsers({required String imageId}) async {
  final user = box.get("user");
  final url = "$prodUrl/api/v1/posts/$imageId/likes";

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      final data = jsonData
          .map((e) => LikedUsers.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return data;
    } else if (response.statusCode == 422 || response.statusCode == 400) {
      final errorJson = json.decode(response.body) as Map;
      final err = ErrorModel.fromJson(errorJson.cast());
      for (final element in err.errors!) {
        Fluttertoast.showToast(msg: element.message!);
      }
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on SocketException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
  return null;
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

Future postComment({required String imageId, required String comment}) async {
  final user = box.get("user");
  final url = "$prodUrl/api/v1/posts/$imageId/comments";
  final body = {"comment": comment};
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${user!.token}",
        "Content-Type": "application/json"
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      controller.update(["commentCount"]);
    } else if (response.statusCode == 422 || response.statusCode == 400) {
      final errorJson = json.decode(response.body) as Map;
      final err = ErrorModel.fromJson(errorJson.cast());
      for (final element in err.errors!) {
        Fluttertoast.showToast(msg: element.message!);
      }
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on SocketException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
}

Future<List<CommentedUsers>?> getCommentedUsers({
  required String imageId,
}) async {
  final user = box.get("user");
  final url = "$prodUrl/api/v1/posts/$imageId/comments";

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      final data = jsonData
          .map(
            (e) => CommentedUsers.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
      return data;
    } else if (response.statusCode == 422 || response.statusCode == 400) {
      final errorJson = json.decode(response.body) as Map;
      final err = ErrorModel.fromJson(errorJson.cast());
      for (final element in err.errors!) {
        Fluttertoast.showToast(msg: element.message!);
      }
    } else {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  } on HttpException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on SocketException {
    Fluttertoast.showToast(msg: "No Internet connection");
  } on PlatformException {
    Fluttertoast.showToast(msg: "Invalid Format");
  }
  return null;
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
