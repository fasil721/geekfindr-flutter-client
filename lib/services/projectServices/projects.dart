import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/controller/controller.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:geek_findr/services/projectServices/project_model_classes.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProjectServices {
  final box = Boxes.getInstance();
  final controller = Get.find<AppController>();

  Future<List<ProjectShortModel>?> getMyProjects() async {
    final user = box.get("user");
    const url = "$prodUrl/api/v1/projects/my-projects";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${user!.token}",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final datas = jsonData
            .map(
              (e) => ProjectShortModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ),
            )
            .toList();
        return datas;
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
    return null;
  }

  Future<ProjectModel?> getProjectDetialsById({
    required String id,
  }) async {
    final user = box.get("user");
    final url = "$prodUrl/api/v1/projects/$id";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${user!.token}",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map;
        final datas =
            ProjectModel.fromJson(Map<String, dynamic>.from(jsonData));
        return datas;
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
    // } catch (e) {
    //   Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  Future<void> editProjectDescription({
    required String projectId,
    required Map<String, String> body,
  }) async {
    final user = box.get("user");
    final url = "$prodUrl/api/v1/projects/$projectId/description";
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${user!.token}",
          "Content-Type": "application/json"
        },
        body: json.encode(body),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        controller.update(["projectList", "projectView"]);
        Get.back();
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

  Future<void> removeMemberFromProject({
    required String projectId,
    required String userName,
    required String memberId,
  }) async {
    final user = box.get("user");
    final url = "$prodUrl/api/v1/projects/$projectId/team/$memberId";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${user!.token}",
        },
      );

      print(response.statusCode);
      // final a = jsonDecode(response.body) as Map;
      // print(a.keys.first == "errors");
      if (response.statusCode == 200) {
        controller.update(["memberList"]);
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

  Future<void> changeMemberRole({
    required String projectId,
    required String role,
    bool newJoin = false,
    required String userName,
    required String memberId,
  }) async {
    final user = box.get("user");
    final url = "$prodUrl/api/v1/projects/$projectId/team/$memberId/role";
    final body = {"role": role};
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${user!.token}",
          "Content-Type": "application/json"
        },
        body: json.encode(body),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        if (newJoin) {
          Fluttertoast.showToast(msg: "You Added $userName to this Project");
        } else {
          // Get.snackbar(
          //   "Role Change",
          //   "You changed $userName role to $role",
          //   snackPosition: SnackPosition.BOTTOM,
          // );
          Fluttertoast.showToast(msg: "You changed $userName role to $role");
        }
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

  Future<void> deleteProject({
    required String projectId,
    required String projectName,
  }) async {
    final user = box.get("user");
    final url = "$prodUrl/api/v1/projects/$projectId";

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${user!.token}",
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "You deleted $projectName");
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

  Future<void> updateProjectTodos({
    required String projectId,
    required List<Todo> todos,
  }) async {
    final user = box.get("user");
    final url = "$prodUrl/api/v1/projects/$projectId/todo";
    final body = {"todo": todos};
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${user!.token}",
          "Content-Type": "application/json"
        },
        body: json.encode(body),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "changes have been saved");
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
