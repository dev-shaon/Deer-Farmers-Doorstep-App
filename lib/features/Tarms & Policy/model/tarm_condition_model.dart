import 'dart:convert';

class TarmConditionModel {
  String? status;
  Data? data;

  TarmConditionModel({this.status, this.data});

  TarmConditionModel copyWith({String? status, Data? data}) =>
      TarmConditionModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory TarmConditionModel.fromRawJson(String str) =>
      TarmConditionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TarmConditionModel.fromJson(Map<String, dynamic> json) =>
      TarmConditionModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  int? id;
  String? title;
  String? slug;
  String? key;
  String? content;
  int? isActive;
  dynamic metaTitle;
  dynamic metaDescription;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.title,
    this.slug,
    this.key,
    this.content,
    this.isActive,
    this.metaTitle,
    this.metaDescription,
    this.createdAt,
    this.updatedAt,
  });

  Data copyWith({
    int? id,
    String? title,
    String? slug,
    String? key,
    String? content,
    int? isActive,
    dynamic metaTitle,
    dynamic metaDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Data(
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    key: key ?? this.key,
    content: content ?? this.content,
    isActive: isActive ?? this.isActive,
    metaTitle: metaTitle ?? this.metaTitle,
    metaDescription: metaDescription ?? this.metaDescription,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    key: json["key"],
    content: json["content"],
    isActive: json["is_active"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "key": key,
    "content": content,
    "is_active": isActive,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
