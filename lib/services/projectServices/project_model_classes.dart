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
  String? owner;
  List<dynamic>? team;
  List<dynamic>? todo;
  List<dynamic>? task;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;

  factory ProjuctDetialsModel.fromJson(Map<String, dynamic> json) =>
      ProjuctDetialsModel(
        description: json["description"] as String,
        name: json["name"] as String,
        owner: json["owner"] as String,
        team: List<dynamic>.from((json["team"] as List).map((x) => x)),
        todo: List<dynamic>.from((json["todo"] as List).map((x) => x)),
        task: List<dynamic>.from((json["task"] as List).map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"] as String),
        updatedAt: DateTime.parse(json["updatedAt"] as String),
        id: json["id"] as String,
      );
}
