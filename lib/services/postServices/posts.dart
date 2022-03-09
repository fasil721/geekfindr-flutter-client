import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:geek_findr/services/postServices/post_models.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PostServices {
   final _currentUser = Boxes.getCurrentUser();

  Future<void> uploadImage({
    required String description,
    required File image,
    required bool isProject,
    String projectName = "",
  }) async {
    const getUrl =
        "$prodUrl/api/v1/uploads/signed-url?fileType=image&fileSubType=jpg";
    const postUrl = "$prodUrl/api/v1/posts/";
    try {
      final response1 = await http.get(
        Uri.parse(getUrl),
        headers: {"Authorization": "Bearer ${_currentUser.token}"},
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
            "Authorization": "Bearer ${_currentUser.token}",
            "Content-Type": "application/json"
          },
        );
        // print(response3.statusCode);
        if (response3.statusCode == 200) {
          if (projectName.isNotEmpty) {
            controller.update(["projectList"]);
            Fluttertoast.showToast(
              msg: "Projest post uploaded",
            );
          } else {
            Fluttertoast.showToast(msg: "Post uploaded");
          }
          controller.update(["postCount"]);
          Get.back();
        } else if (response3.statusCode == 400 || response3.statusCode == 422) {
          final errorJson = json.decode(response3.body) as Map;
          final err = ErrorModel.fromJson(errorJson.cast());
          for (final element in err.errors!) {
            Fluttertoast.showToast(msg: element.message!);
          }
        } else {
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

  Future<List<ImageModel>> getMyImages(String id) async {
    // await Future.delayed(Duration(seconds: 5));

    final url = "$prodUrl/api/v1/posts/by-users/$id";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${_currentUser.token}"},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final data = jsonData
            .map(
              (e) => ImageModel.fromJson(Map<String, dynamic>.from(e as Map)),
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
    // await Future.delayed(const Duration(seconds: 5));
    String url = "$prodUrl/api/v1/posts/my-feed?limit=5";
    if (lastId != null) {
      url = "$prodUrl/api/v1/posts/my-feed?limit=5&lastId=$lastId";
    }
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${_currentUser.token}"},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final data = jsonData
            .map(
              (e) => ImageModel.fromJson(Map<String, dynamic>.from(e as Map)),
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
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet connection");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    }
    return [];
  }

  Future<void> deleteImage({required String imageId}) async {
    final url = "$prodUrl/api/v1/posts/$imageId";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${_currentUser.token}"},
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

  Future<void> editImage({required String imageId, required Map body}) async {
    final url = "$prodUrl/api/v1/posts/$imageId";

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          "Authorization": "Bearer ${_currentUser.token}",
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
    final url = "$prodUrl/api/v1/posts/$imageId/likes";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${_currentUser.token}"},
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
    final url = "$prodUrl/api/v1/posts/$imageId/likes";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${_currentUser.token}"},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final data = jsonData
            .map(
              (e) => LikedUsers.fromJson(Map<String, dynamic>.from(e as Map)),
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

  Future<void> postComment({
    required String imageId,
    required String comment,
  }) async {
    final url = "$prodUrl/api/v1/posts/$imageId/comments";
    final body = {"comment": comment};
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${_currentUser.token}",
          "Content-Type": "application/json"
        },
        body: json.encode(body),
      );
      print(response.statusCode);
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
    await Future.delayed(const Duration(seconds: 1));

    final url = "$prodUrl/api/v1/posts/$imageId/comments";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${_currentUser.token}"},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final data = jsonData
            .map(
              (e) =>
                  CommentedUsers.fromJson(Map<String, dynamic>.from(e as Map)),
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

  Future<void> sendJoinRequest({
    required String projectId,
    required String projectName,
  }) async {
    final url = "$prodUrl/api/v1/posts/$projectId/team-join-requests";
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${_currentUser.token}",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "You have sent join request to $projectName",
        );
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
      Fluttertoast.showToast(msg: "No Internet");
    } on SocketException {
      Fluttertoast.showToast(msg: "No Internet");
    } on PlatformException {
      Fluttertoast.showToast(msg: "Invalid Format");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
