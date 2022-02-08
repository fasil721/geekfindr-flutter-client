import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

final box = Hive.box('usermodel');
Future<void> postImage() async {
  final user = box.get("user") as UserModel;
  final imagePicker = ImagePicker();
  const getUrl =
      "$prodUrl/api/v1/uploads/signed-url?fileType=image&fileSubType=jpg";
  const postUrl = "$prodUrl/api/v1/posts/";

  final image = await imagePicker.pickImage(source: ImageSource.camera);
  if (image != null) {
    final croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    try {
      final response1 = await http.get(
        Uri.parse(getUrl),
        headers: {"Authorization": "Bearer ${user.token}"},
      );
      final jsonData = json.decode(response1.body) as Map;
      final data = Signedurl.fromJson(jsonData.cast());
      final response2 = await http.put(
        Uri.parse(data.url!),
        body: croppedFile!.readAsBytesSync(),
        headers: {"Content-Type": "image/jpg"},
      );

      final postImage = PostImage();
      postImage.description = "hai guys";
      postImage.isOrganization = false;
      postImage.isProject = false;
      postImage.mediaUrl = data.key;
      postImage.mediaType = "image";
      final response3 = await http.post(
        Uri.parse(postUrl),
        body: json.encode(postImage.toJson()),
        headers: {
          "Authorization": "Bearer ${user.token}",
          "Content-Type": "application/json"
        },
      );
      final jsonData2 = json.decode(response3.body) as Map;
      final data2 = PostImage.fromJson(jsonData2.cast());
      print(croppedFile.readAsBytesSync());
      print(response2.statusCode);
      print(response3.statusCode);
      print(data2.toJson());
    } on HttpException {
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    }
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

class PostImage {
  String? mediaType;
  bool? isProject;
  String? mediaUrl;
  String? description;
  bool? isOrganization;
  String? owner;
  int? likeCount;
  List<dynamic>? comments;
  List<dynamic>? teamJoinRequests;
  String? createdAt;
  String? updatedAt;
  String? id;

  PostImage({
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

  factory PostImage.fromJson(Map<String, dynamic> json) => PostImage(
        mediaType: json["mediaType"] as String,
        owner: json["owner"] as String,
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

Future<List<PostImage>> getMyImages() async {
  final user = box.get("user") as UserModel;
  const url = "$prodUrl/api/v1/posts/my-posts";

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer ${user.token}"},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      final data = jsonData
          .map((e) => PostImage.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      // print(data.first.toJson());
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
