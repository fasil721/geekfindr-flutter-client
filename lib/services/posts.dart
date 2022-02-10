import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final box = Boxes.getInstance();
final controller = Get.find<AppController>();
Future<void> uploadImage({
  required String description,
  required File image,
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

    final imageModel = ImageModel();
    imageModel.description = description;
    imageModel.isOrganization = false;
    imageModel.isProject = false;
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
    if (response3.statusCode == 200) {
      // final jsonData2 = json.decode(response3.body) as Map;
      // final data2 = ImageModel.fromJson(jsonData2.cast());  print(data2.toJson());
      Fluttertoast.showToast(msg: "Image uploaded");

      Get.back();
    } else {
      Fluttertoast.showToast(msg: "Image not uploaded");
    }

    print(image.readAsBytesSync());
    print(response2.statusCode);
    print(response3.statusCode);
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
  String? mediaType;
  bool? isProject;
  String? mediaUrl;
  String? description;
  bool? isOrganization;
  Owner? owner;
  int? likeCount;
  List<dynamic>? comments;
  List<dynamic>? teamJoinRequests;
  String? createdAt;
  String? updatedAt;
  String? id;

  ImageModel({
    this.mediaType,
    this.owner,
    this.isProject,
    this.mediaUrl,
    this.description,
    this.likeCount,
    this.comments,
    this.teamJoinRequests,
    this.isOrganization,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        mediaType: json["mediaType"] as String,
        owner: Owner.fromJson(Map<String, String>.from(json["owner"] as Map)),
        isProject: json["isProject"] as bool,
        mediaUrl: json["mediaURL"] as String,
        description: json["description"] as String,
        likeCount: json["likeCount"] as int,
        comments: List<dynamic>.from(
          (json["comments"] as List).map((x) => x),
        ),
        teamJoinRequests: List<dynamic>.from(
          (json["teamJoinRequests"] as List).map((x) => x),
        ),
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
      };
}

Future<List<ImageModel>> getMyImages() async {
  final user = box.get("user");
  const url = "$prodUrl/api/v1/posts/my-posts";

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      final data = jsonData
          .map((e) => ImageModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      // print(data.first.owner!.toJson());
      return data;
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

Future<List<ImageModel>> getMyFeeds() async {
  final user = box.get("user");
  const url = "$prodUrl/api/v1/posts/my-feed?limit=5";

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user!.token}"},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      final data = jsonData
          .map((e) => ImageModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      // print(data.first.owner!.toJson());
      return data;
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
      controller.update(["mypost"]);
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
