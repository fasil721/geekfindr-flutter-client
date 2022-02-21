

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
