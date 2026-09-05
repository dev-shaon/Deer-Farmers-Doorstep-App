import 'dart:convert';

class NotificationModel {
  bool? success;
  String? message;
  NotificationModelData? data;
  dynamic errors;
  int? code;

  NotificationModel({
    this.success,
    this.message,
    this.data,
    this.errors,
    this.code,
  });

  NotificationModel copyWith({
    bool? success,
    String? message,
    NotificationModelData? data,
    dynamic errors,
    int? code,
  }) =>
      NotificationModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        errors: errors ?? this.errors,
        code: code ?? this.code,
      );

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : NotificationModelData.fromJson(json["data"]),
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

class NotificationModelData {
  List<NotificationItem>? notifications;
  Pagination? pagination;
  int? unreadCount;

  NotificationModelData({
    this.notifications,
    this.pagination,
    this.unreadCount,
  });

  NotificationModelData copyWith({
    List<NotificationItem>? notifications,
    Pagination? pagination,
    int? unreadCount,
  }) =>
      NotificationModelData(
        notifications: notifications ?? this.notifications,
        pagination: pagination ?? this.pagination,
        unreadCount: unreadCount ?? this.unreadCount,
      );

  factory NotificationModelData.fromRawJson(String str) =>
      NotificationModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModelData.fromJson(Map<String, dynamic> json) =>
      NotificationModelData(
        notifications: json["notifications"] == null
            ? []
            : List<NotificationItem>.from(
                json["notifications"]!.map((x) => NotificationItem.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        unreadCount: json["unread_count"],
      );

  Map<String, dynamic> toJson() => {
        "notifications": notifications == null
            ? []
            : List<dynamic>.from(notifications!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
        "unread_count": unreadCount,
      };
}

class NotificationItem {
  String? id;
  String? type;
  bool? isRead;
  dynamic readAt;
  DateTime? createdAt;
  NotificationData? data;

  NotificationItem({
    this.id,
    this.type,
    this.isRead,
    this.readAt,
    this.createdAt,
    this.data,
  });

  NotificationItem copyWith({
    String? id,
    String? type,
    bool? isRead,
    dynamic readAt,
    DateTime? createdAt,
    NotificationData? data,
  }) =>
      NotificationItem(
        id: id ?? this.id,
        type: type ?? this.type,
        isRead: isRead ?? this.isRead,
        readAt: readAt ?? this.readAt,
        createdAt: createdAt ?? this.createdAt,
        data: data ?? this.data,
      );

  factory NotificationItem.fromRawJson(String str) =>
      NotificationItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json["id"],
        type: json["type"],
        isRead: json["is_read"],
        readAt: json["read_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        data: json["data"] == null
            ? null
            : NotificationData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "is_read": isRead,
        "read_at": readAt,
        "created_at": createdAt?.toIso8601String(),
        "data": data?.toJson(),
      };
}

class NotificationData {
  int? farmId;
  String? farmName;
  String? action;
  String? message;
  String? thumbnail;
  String? city;

  NotificationData({
    this.farmId,
    this.farmName,
    this.action,
    this.message,
    this.thumbnail,
    this.city,
  });

  NotificationData copyWith({
    int? farmId,
    String? farmName,
    String? action,
    String? message,
    String? thumbnail,
    String? city,
  }) =>
      NotificationData(
        farmId: farmId ?? this.farmId,
        farmName: farmName ?? this.farmName,
        action: action ?? this.action,
        message: message ?? this.message,
        thumbnail: thumbnail ?? this.thumbnail,
        city: city ?? this.city,
      );

  factory NotificationData.fromRawJson(String str) =>
      NotificationData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        farmId: json["farm_id"],
        farmName: json["farm_name"],
        action: json["action"],
        message: json["message"],
        thumbnail: json["thumbnail"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "farm_id": farmId,
        "farm_name": farmName,
        "action": action,
        "message": message,
        "thumbnail": thumbnail,
        "city": city,
      };
}

class Pagination {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Pagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  Pagination copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? lastPage,
  }) =>
      Pagination(
        total: total ?? this.total,
        perPage: perPage ?? this.perPage,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
      );

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
        "current_page": currentPage,
        "last_page": lastPage,
      };
}