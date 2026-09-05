import 'dart:convert';

class FarmsModel {
  bool? success;
  String? message;
  Data? data;
  dynamic errors;
  int? code;

  FarmsModel({this.success, this.message, this.data, this.errors, this.code});

  FarmsModel copyWith({
    bool? success,
    String? message,
    Data? data,
    dynamic errors,
    int? code,
  }) => FarmsModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    errors: errors ?? this.errors,
    code: code ?? this.code,
  );

  factory FarmsModel.fromRawJson(String str) =>
      FarmsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FarmsModel.fromJson(Map<String, dynamic> json) => FarmsModel(
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
  List<Farm>? farms;
  Pagination? pagination;

  Data({this.farms, this.pagination});

  Data copyWith({List<Farm>? farms, Pagination? pagination}) => Data(
    farms: farms ?? this.farms,
    pagination: pagination ?? this.pagination,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    farms: json["farms"] == null
        ? []
        : List<Farm>.from(json["farms"]!.map((x) => Farm.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "farms": farms == null
        ? []
        : List<dynamic>.from(farms!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Farm {
  int? id;
  String? type;
  String? name;
  String? address;
  String? city;
  String? state;
  String? country;
  double? latitude;
  double? longitude;
  String? thumbnail;
  dynamic tags;
  String? status;
  bool? isFeatured;
  String? phone;
  String? markerColor;
  String? markerIcon;
  String? ownerName;
  String? ownerAddress;
  String? ownerPhone;
  String? ownerAvatar;
  bool? isFavorite;
  bool? isVisited;

  Farm({
    this.id,
    this.type,
    this.name,
    this.address,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.thumbnail,
    this.tags,
    this.status,
    this.isFeatured,
    this.phone,
    this.markerColor,
    this.markerIcon,
    this.ownerName,
    this.ownerAddress,
    this.ownerPhone,
    this.ownerAvatar,
    this.isFavorite,
    this.isVisited,
  });

  Farm copyWith({
    int? id,
    String? type,
    String? name,
    String? address,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    String? thumbnail,
    dynamic tags,
    String? status,
    bool? isFeatured,
    String? phone,
    String? markerColor,
    String? markerIcon,
    String? ownerName,
    String? ownerAddress,
    String? ownerPhone,
    String? ownerAvatar,
    bool? isFavorite,
    bool? isVisited,
  }) => Farm(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    address: address ?? this.address,
    city: city ?? this.city,
    state: state ?? this.state,
    country: country ?? this.country,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    thumbnail: thumbnail ?? this.thumbnail,
    tags: tags ?? this.tags,
    status: status ?? this.status,
    isFeatured: isFeatured ?? this.isFeatured,
    phone: phone ?? this.phone,
    markerColor: markerColor ?? this.markerColor,
    markerIcon: markerIcon ?? this.markerIcon,
    ownerName: ownerName ?? this.ownerName,
    ownerAddress: ownerAddress ?? this.ownerAddress,
    ownerPhone: ownerPhone ?? this.ownerPhone,
    ownerAvatar: ownerAvatar ?? this.ownerAvatar,
    isFavorite: isFavorite ?? this.isFavorite,
    isVisited: isVisited ?? this.isVisited,
  );

  factory Farm.fromRawJson(String str) => Farm.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    thumbnail: json["thumbnail"],
    tags: json["tags"],
    status: json["status"],
    isFeatured: json["is_featured"],
    phone: json["phone"],
    markerColor: json["marker_color"],
    markerIcon: json["marker_icon"],
    ownerName: json["owner_name"],
    ownerAddress: json["owner_address"],
    ownerPhone: json["owner_phone"],
    ownerAvatar: json["owner_avatar"],
    isFavorite: json["is_favorite"],
    isVisited: json["is_visited"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "latitude": latitude,
    "longitude": longitude,
    "thumbnail": thumbnail,
    "tags": tags,
    "status": status,
    "is_featured": isFeatured,
    "phone": phone,
    "marker_color": markerColor,
    "marker_icon": markerIcon,
    "owner_name": ownerName,
    "owner_address": ownerAddress,
    "owner_phone": ownerPhone,
    "owner_avatar": ownerAvatar,
    "is_favorite": isFavorite,
    "is_visited": isVisited,
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
