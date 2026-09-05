import 'dart:convert';

class NoteDetailsModel {
    bool? success;
    String? message;
    Data? data;
    dynamic errors;
    int? code;

    NoteDetailsModel({
        this.success,
        this.message,
        this.data,
        this.errors,
        this.code,
    });

    NoteDetailsModel copyWith({
        bool? success,
        String? message,
        Data? data,
        dynamic errors,
        int? code,
    }) => 
        NoteDetailsModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
            errors: errors ?? this.errors,
            code: code ?? this.code,
        );

    factory NoteDetailsModel.fromRawJson(String str) => NoteDetailsModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory NoteDetailsModel.fromJson(Map<String, dynamic> json) => NoteDetailsModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        errors: json["errors"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "errors": errors,
        "code": code,
    };
}

class Data {
    Note? note;

    Data({
        this.note,
    });

    Data copyWith({
        Note? note,
    }) => 
        Data(
            note: note ?? this.note,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        note: json["note"] == null ? null : Note.fromJson(json["note"]),
    );

    Map<String, dynamic> toJson() => {
        "note": note?.toJson(),
    };
}

class Note {
    int? id;
    String? title;
    String? content;
    String? color;
    DateTime? createdAt;
    DateTime? updatedAt;

    Note({
        this.id,
        this.title,
        this.content,
        this.color,
        this.createdAt,
        this.updatedAt,
    });

    Note copyWith({
        int? id,
        String? title,
        String? content,
        String? color,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Note(
            id: id ?? this.id,
            title: title ?? this.title,
            content: content ?? this.content,
            color: color ?? this.color,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Note.fromRawJson(String str) => Note.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        color: json["color"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "color": color,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
