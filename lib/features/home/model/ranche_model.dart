import 'dart:convert';

List<String> _parseTags(dynamic rawTags) {
  if (rawTags == null) return [];

  if (rawTags is List) {
    return rawTags.map((e) => e.toString()).toList();
  }

  if (rawTags is String) {
    final value = rawTags.trim();
    if (value.isEmpty) return [];

    try {
      final decoded = json.decode(value);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {
      // Fallback to comma-separated parsing.
    }

    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  return [];
}

class RancheModel {
  bool? success;
  String? message;
  Data? data;
  dynamic errors;
  int? code;

  RancheModel({this.success, this.message, this.data, this.errors, this.code});

  RancheModel copyWith({
    bool? success,
    String? message,
    Data? data,
    dynamic errors,
    int? code,
  }) => RancheModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    errors: errors ?? this.errors,
    code: code ?? this.code,
  );

  factory RancheModel.fromRawJson(String str) =>
      RancheModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RancheModel.fromJson(Map<String, dynamic> json) => RancheModel(
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
  List<Ranch>? ranches;
  Pagination? pagination;

  Data({this.ranches, this.pagination});

  Data copyWith({List<Ranch>? ranches, Pagination? pagination}) => Data(
    ranches: ranches ?? this.ranches,
    pagination: pagination ?? this.pagination,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ranches: json["ranches"] == null
        ? []
        : List<Ranch>.from(json["ranches"]!.map((x) => Ranch.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "ranches": ranches == null
        ? []
        : List<dynamic>.from(ranches!.map((x) => x.toJson())),
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

class Ranch {
  int? id;
  String? type;
  String? name;
  String? address;
  String? city;
  String? state;
  String? country;
  double? latitude;
  double? longitude;
  dynamic thumbnail;
  List<String>? tags;
  int? acreage;
  String? status;
  bool? isFeatured;
  String? phone;
  String? markerColor;
  String? markerIcon;
  bool? isFavorite;
  bool? isVisited;
  String? ownerName;
  String? ownerAddress;
  String? ownerPhone;
  String? ownerAvatar;

  Ranch({
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
    this.acreage,
    this.status,
    this.isFeatured,
    this.phone,
    this.markerColor,
    this.markerIcon,
    this.isFavorite,
    this.isVisited,
    this.ownerName,
    this.ownerAddress,
    this.ownerPhone,
    this.ownerAvatar,
  });

  Ranch copyWith({
    int? id,
    String? type,
    String? name,
    String? address,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    dynamic thumbnail,
    List<String>? tags,
    int? acreage,
    String? status,
    bool? isFeatured,
    String? phone,
    String? markerColor,
    String? markerIcon,
    bool? isFavorite,
    bool? isVisited,
    String? ownerName,
    String? ownerAddress,
    String? ownerPhone,
    String? ownerAvatar,
  }) => Ranch(
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
    acreage: acreage ?? this.acreage,
    status: status ?? this.status,
    isFeatured: isFeatured ?? this.isFeatured,
    phone: phone ?? this.phone,
    markerColor: markerColor ?? this.markerColor,
    markerIcon: markerIcon ?? this.markerIcon,
    isFavorite: isFavorite ?? this.isFavorite,
    isVisited: isVisited ?? this.isVisited,
    ownerName: ownerName ?? this.ownerName,
    ownerAddress: ownerAddress ?? this.ownerAddress,
    ownerPhone: ownerPhone ?? this.ownerPhone,
    ownerAvatar: ownerAvatar ?? this.ownerAvatar,
  );

  factory Ranch.fromRawJson(String str) => Ranch.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ranch.fromJson(Map<String, dynamic> json) => Ranch(
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
    tags: _parseTags(json["tags"]),
    acreage: json["acreage"],
    status: json["status"],
    isFeatured: json["is_featured"],
    phone: json["phone"],
    markerColor: json["marker_color"],
    markerIcon: json["marker_icon"],
    isFavorite: json["is_favorite"],
    isVisited: json["is_visited"],
    ownerName: json["owner_name"],
    ownerAddress: json["owner_address"],
    ownerPhone: json["owner_phone"],
    ownerAvatar: json["owner_avatar"],
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
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "acreage": acreage,
    "status": status,
    "is_featured": isFeatured,
    "phone": phone,
    "marker_color": markerColor,
    "marker_icon": markerIcon,
    "is_favorite": isFavorite,
    "is_visited": isVisited,
    "owner_name": ownerName,
    "owner_address": ownerAddress,
    "owner_phone": ownerPhone,
    "owner_avatar": ownerAvatar,
  };
}
