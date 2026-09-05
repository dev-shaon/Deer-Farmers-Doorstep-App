import 'dart:convert';

class VisitedModel {
  bool? success;
  String? message;
  Data? data;
  dynamic errors;
  int? code;

  VisitedModel({this.success, this.message, this.data, this.errors, this.code});

  VisitedModel copyWith({
    bool? success,
    String? message,
    Data? data,
    dynamic errors,
    int? code,
  }) => VisitedModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    errors: errors ?? this.errors,
    code: code ?? this.code,
  );

  factory VisitedModel.fromRawJson(String str) =>
      VisitedModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VisitedModel.fromJson(Map<String, dynamic> json) => VisitedModel(
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
  List<Visited>? visited;
  Pagination? pagination;

  Data({this.visited, this.pagination});

  Data copyWith({List<Visited>? visited, Pagination? pagination}) => Data(
    visited: visited ?? this.visited,
    pagination: pagination ?? this.pagination,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    visited: json["visited"] == null
        ? []
        : List<Visited>.from(json["visited"]!.map((x) => Visited.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "visited": visited == null
        ? []
        : List<dynamic>.from(visited!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination({this.currentPage, this.lastPage, this.perPage, this.total});

  Pagination copyWith({
    int? currentPage,
    int? lastPage,
    int? perPage,
    int? total,
  }) => Pagination(
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    perPage: perPage ?? this.perPage,
    total: total ?? this.total,
  );

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"],
    lastPage: json["last_page"],
    perPage: json["per_page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "last_page": lastPage,
    "per_page": perPage,
    "total": total,
  };
}

class Visited {
  int? id;
  DateTime? visitedAt;
  dynamic note;
  dynamic userLat;
  dynamic userLng;
  Item? item;

  Visited({
    this.id,
    this.visitedAt,
    this.note,
    this.userLat,
    this.userLng,
    this.item,
  });

  Visited copyWith({
    int? id,
    DateTime? visitedAt,
    dynamic note,
    dynamic userLat,
    dynamic userLng,
    Item? item,
  }) => Visited(
    id: id ?? this.id,
    visitedAt: visitedAt ?? this.visitedAt,
    note: note ?? this.note,
    userLat: userLat ?? this.userLat,
    userLng: userLng ?? this.userLng,
    item: item ?? this.item,
  );

  factory Visited.fromRawJson(String str) => Visited.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Visited.fromJson(Map<String, dynamic> json) => Visited(
    id: json["id"],
    visitedAt: json["visited_at"] == null
        ? null
        : DateTime.parse(json["visited_at"]),
    note: json["note"],
    userLat: json["user_lat"],
    userLng: json["user_lng"],
    item: json["item"] == null ? null : Item.fromJson(json["item"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "visited_at": visitedAt?.toIso8601String(),
    "note": note,
    "user_lat": userLat,
    "user_lng": userLng,
    "item": item?.toJson(),
  };
}

class Item {
  int? id;
  String? type;
  String? name;
  String? address;
  String? city;
  double? latitude;
  double? longitude;
  String? thumbnail;
  String? phone;
  String? markerColor;
  String? markerIcon;
  String? status;
  bool? isFeatured;
  String? ownerName;
  String? ownerAddress;
  String? ownerPhone;
  String? resolvedAddress;

  Item({
    this.id,
    this.type,
    this.name,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.thumbnail,
    this.phone,
    this.markerColor,
    this.markerIcon,
    this.status,
    this.isFeatured,
    this.ownerName,
    this.ownerAddress,
    this.ownerPhone,
    this.resolvedAddress,
  });

  Item copyWith({
    int? id,
    String? type,
    String? name,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
    String? thumbnail,
    String? phone,
    String? markerColor,
    String? markerIcon,
    String? status,
    bool? isFeatured,
    String? ownerName,
    String? ownerAddress,
    String? ownerPhone,
    String? resolvedAddress,
  }) => Item(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    address: address ?? this.address,
    city: city ?? this.city,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    thumbnail: thumbnail ?? this.thumbnail,
    phone: phone ?? this.phone,
    markerColor: markerColor ?? this.markerColor,
    markerIcon: markerIcon ?? this.markerIcon,
    status: status ?? this.status,
    isFeatured: isFeatured ?? this.isFeatured,
    ownerName: ownerName ?? this.ownerName,
    ownerAddress: ownerAddress ?? this.ownerAddress,
    ownerPhone: ownerPhone ?? this.ownerPhone,
    resolvedAddress: resolvedAddress ?? this.resolvedAddress,
  );

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    address: json["address"],
    city: json["city"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    thumbnail: json["thumbnail"],
    phone: json["phone"],
    markerColor: json["marker_color"],
    markerIcon: json["marker_icon"],
    status: json["status"],
    isFeatured: json["is_featured"],
    ownerName: json["owner_name"],
    ownerAddress: json["owner_address"],
    ownerPhone: json["owner_phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "address": address,
    "city": city,
    "latitude": latitude,
    "longitude": longitude,
    "thumbnail": thumbnail,
    "phone": phone,
    "marker_color": markerColor,
    "marker_icon": markerIcon,
    "status": status,
    "is_featured": isFeatured,
    "owner_name": ownerName,
    "owner_address": ownerAddress,
    "owner_phone": ownerPhone,
  };
}
