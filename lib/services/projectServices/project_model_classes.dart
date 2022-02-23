import 'package:geek_findr/services/postServices/post_models.dart';

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

class ProjuctDetialsModel {
  ProjuctDetialsModel({
    this.description,
    this.name,
    this.owner,
    this.team,
    this.todo,
    this.task,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  String? description;
  String? name;
  Owner? owner;
  List<Team>? team;
  List<dynamic>? todo;
  List<dynamic>? task;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;

  factory ProjuctDetialsModel.fromJson(Map<String, dynamic> json) =>
      ProjuctDetialsModel(
        description: json["description"] as String,
        name: json["name"] as String,
        owner: Owner.fromJson(
          Map<String, String>.from((json["user"])! as Map),
        ),
        team: List<Team>.from(
          (json["team"] as List)
              .map((x) => Team.fromJson(Map<String, String>.from(x as Map))),
        ),
        todo: List<dynamic>.from((json["todo"] as List).map((x) => x)),
        task: List<dynamic>.from((json["task"] as List).map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"] as String),
        updatedAt: DateTime.parse(json["updatedAt"] as String),
        id: json["id"] as String,
      );
}

class Team {
  Team({
    this.user,
    this.role,
  });

  Owner? user;
  String? role;

  factory Team.fromJson(Map<String, String> json) => Team(
        user: Owner.fromJson(
          Map<String, String>.from((json["user"])! as Map),
        ),
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "user": user!.toJson(),
        "role": role,
      };
}
