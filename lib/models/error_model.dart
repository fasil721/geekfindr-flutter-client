class ErrorModel {
  ErrorModel({
    this.errors,
  });

  List<Error>? errors;

  factory ErrorModel.fromJson(Map<String, List> json) => ErrorModel(
        errors: List<Error>.from(
          json["errors"]!
              .map((x) => Error.fromJson(Map<String, String>.from(x as Map))),
        ),
      );

  Map<String, dynamic> toJson() => {
        "errors": List<dynamic>.from(errors!.map((x) => x.toJson())),
      };
}

class Error {
  Error({
    this.message,
    this.field,
  });

  String? message;
  String? field;

  factory Error.fromJson(Map<String, String> json) => Error(
        message: json["message"],
        field: json["field"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "field": field,
      };
}
