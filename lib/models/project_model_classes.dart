import 'package:geek_findr/constants.dart';
import 'package:geek_findr/models/post_models.dart';

class ProjectShortModel {
  ProjectShortModel({
    this.project,
    this.role,
  });

  ProjectShortDataModel? project;
  String? role;

  factory ProjectShortModel.fromJson(Map<String, dynamic> json) =>
      ProjectShortModel(
        project: ProjectShortDataModel.fromJson(
          Map<String, dynamic>.from(json["project"] as Map),
        ),
        role: json["role"] as String,
      );

  Map<String, dynamic> toJson() => {
        "project": project!.toJson(),
        "role": role,
      };
}

class ProjectShortDataModel {
  ProjectShortDataModel({
    this.description,
    this.name,
    this.owner,
    this.id,
  });
  String? description;
  Owner? owner;
  String? name;
  String? id;

  factory ProjectShortDataModel.fromJson(Map<String, dynamic> json) =>
      ProjectShortDataModel(
        description: json["description"] as String,
        name: json["name"] as String,
        owner: Owner.fromJson(
          Map<String, String>.from((json["owner"])! as Map),
        ),
        id: json["id"] as String,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class ProjectModel {
  ProjectModel({
    this.project,
    this.role,
  });

  ProjectDataModel? project;
  String? role;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        project: ProjectDataModel.fromJson(
          Map<String, dynamic>.from(json["project"] as Map),
        ),
        role: json["role"] as String,
      );
}

class ProjectDataModel {
  ProjectDataModel({
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
  List<Todo>? todo;
  List<Task>? task;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? id;

  factory ProjectDataModel.fromJson(Map<String, dynamic> json) =>
      ProjectDataModel(
        description: json["description"] as String,
        name: json["name"] as String,
        owner: Owner.fromJson(
          Map<String, String>.from(json["owner"] as Map),
        ),
        team: List<Team>.from(
          (json["team"] as List)
              .map((x) => Team.fromJson(Map<String, dynamic>.from(x as Map))),
        ),
        todo: List<Todo>.from(
          (json["todo"] as List)
              .map((x) => Todo.fromJson(Map<String, dynamic>.from(x as Map))),
        ),
        task: List<Task>.from(
          (json["task"] as List)
              .map((x) => Task.fromJson(Map<String, dynamic>.from(x as Map))),
        ),
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

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        user: Owner.fromJson(
          Map<String, String>.from(json["user"] as Map),
        ),
        role: json["role"] as String,
      );

  Map<String, dynamic> toJson() => {
        "user": user!.toJson(),
        "role": role,
      };
}

class Todo {
  Todo({
    this.title,
    this.tasks,
  });

  String? title;
  List<String>? tasks;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json["title"] as String,
        tasks: List<String>.from((json["tasks"] as List).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "tasks": List<String>.from(tasks!.map((x) => x)),
      };
}

class Task {
  Task({
    this.title,
    this.description,
    this.users,
    this.isComplete,
    this.assignor,
  });

  String? title;
  String? description;
  List<String>? users;
  bool? isComplete;
  Owner? assignor;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json["title"] as String,
        description: json["description"] as String,
        users: List<String>.from((json["users"] as List).map((x) => x)),
        isComplete: json["isComplete"] as bool,
        assignor:
            Owner.fromJson(Map<String, String>.from(json["assignor"] as Map)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "users": List<String>.from(users!.map((x) => x)),
        "isComplete": isComplete,
        "assignor": assignor!.id,
      };
}
