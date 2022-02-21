import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geek_findr/contants.dart';
import 'package:geek_findr/models/box_instance.dart';
import 'package:geek_findr/models/error_model.dart';
import 'package:http/http.dart' as http;

class ProjectServices {
  final box = Boxes.getInstance();

  Future<List<ProjectListModel>?> getMyProjects() async {
    final user = box.get("user");
    const url = "$prodUrl/api/v1/projects/my-projects";
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${user!.token}",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List;
        final datas = jsonData
            .map(
              (e) => ProjectListModel.fromJson(
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
}

class ProjectListModel {
  ProjectListModel({
    this.project,
    this.role,
  });

  Project? project;
  String? role;

  factory ProjectListModel.fromJson(Map<String, dynamic> json) =>
      ProjectListModel(
        project:
            Project.fromJson(Map<String, String>.from(json["project"] as Map)),
        role: json["role"] as String,
      );

  Map<String, dynamic> toJson() => {
        "project": project!.toJson(),
        "role": role,
      };
}

class Project {
  Project({
    this.name,
    this.id,
  });

  String? name;
  String? id;

  factory Project.fromJson(Map<String, String> json) => Project(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
