import 'dart:convert';

class PromptsResponse {
  bool? status;
  int? code;
  String? message;
  List<Datum>? data;

  PromptsResponse({this.status, this.code, this.message, this.data});

  PromptsResponse copyWith({
    bool? status,
    int? code,
    String? message,
    List<Datum>? data,
  }) => PromptsResponse(
    status: status ?? this.status,
    code: code ?? this.code,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory PromptsResponse.fromRawJson(String str) =>
      PromptsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PromptsResponse.fromJson(Map<String, dynamic> json) =>
      PromptsResponse(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "code": code,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  String? slug;
  List<Question>? questions;

  Datum({this.id, this.name, this.slug, this.questions});

  Datum copyWith({
    int? id,
    String? name,
    String? slug,
    List<Question>? questions,
  }) => Datum(
    id: id ?? this.id,
    name: name ?? this.name,
    slug: slug ?? this.slug,
    questions: questions ?? this.questions,
  );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    questions: json["questions"] == null
        ? []
        : List<Question>.from(
            json["questions"]!.map((x) => Question.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "questions": questions == null
        ? []
        : List<dynamic>.from(questions!.map((x) => x.toJson())),
  };
}

class Question {
  int? id;
  int? categoryId;
  String? question;
  String? status;
  bool? isAnswered;

  Question({
    this.id,
    this.categoryId,
    this.question,
    this.status,
    this.isAnswered,
  });

  Question copyWith({
    int? id,
    int? categoryId,
    String? question,
    String? status,
    bool? isAnswered,
  }) => Question(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    question: question ?? this.question,
    status: status ?? this.status,
    isAnswered: isAnswered ?? this.isAnswered,
  );

  factory Question.fromRawJson(String str) =>
      Question.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    categoryId: json["category_id"],
    question: json["question"],
    status: json["status"],
    isAnswered: json["is_answered"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "question": question,
    "status": status,
    "is_answered": isAnswered,
  };
}
