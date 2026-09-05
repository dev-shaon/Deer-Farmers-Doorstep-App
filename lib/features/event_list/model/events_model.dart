import 'dart:convert';

class EventsModel {
  bool? success;
  String? message;
  Data? data;
  dynamic errors;
  int? code;

  EventsModel({this.success, this.message, this.data, this.errors, this.code});

  EventsModel copyWith({
    bool? success,
    String? message,
    Data? data,
    dynamic errors,
    int? code,
  }) => EventsModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    errors: errors ?? this.errors,
    code: code ?? this.code,
  );

  factory EventsModel.fromRawJson(String str) =>
      EventsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventsModel.fromJson(Map<String, dynamic> json) => EventsModel(
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
  List<Event>? events;
  Pagination? pagination;

  Data({this.events, this.pagination});

  Data copyWith({List<Event>? events, Pagination? pagination}) => Data(
    events: events ?? this.events,
    pagination: pagination ?? this.pagination,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    events: json["events"] == null
        ? []
        : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
    pagination: json["pagination"] == null
        ? null
        : Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "events": events == null
        ? []
        : List<dynamic>.from(events!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Event {
  int? id;
  String? type;
  String? title;
  String? address;
  String? city;
  String? state;
  String? country;
  double? latitude;
  double? longitude;
  dynamic image;
  DateTime? startDate;
  DateTime? endDate;
  dynamic isFree;
  int? entryFee;
  int? capacity;
  String? status;
  String? phone;
  String? markerColor;
  String? markerIcon;
  Owner? owner;
  bool? isFavorite;
  bool? isVisited;

  Event({
    this.id,
    this.type,
    this.title,
    this.address,
    this.city,
    this.state,
    this.country,
    this.latitude,
    this.longitude,
    this.image,
    this.startDate,
    this.endDate,
    this.isFree,
    this.entryFee,
    this.capacity,
    this.status,
    this.phone,
    this.markerColor,
    this.markerIcon,
    this.owner,
    this.isFavorite,
    this.isVisited,
  });

  Event copyWith({
    int? id,
    String? type,
    String? title,
    String? address,
    String? city,
    String? state,
    String? country,
    double? latitude,
    double? longitude,
    dynamic image,
    DateTime? startDate,
    DateTime? endDate,
    dynamic isFree,
    int? entryFee,
    int? capacity,
    String? status,
    String? phone,
    String? markerColor,
    String? markerIcon,
    Owner? owner,
    bool? isFavorite,
    bool? isVisited,
  }) => Event(
    id: id ?? this.id,
    type: type ?? this.type,
    title: title ?? this.title,
    address: address ?? this.address,
    city: city ?? this.city,
    state: state ?? this.state,
    country: country ?? this.country,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    image: image ?? this.image,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    isFree: isFree ?? this.isFree,
    entryFee: entryFee ?? this.entryFee,
    capacity: capacity ?? this.capacity,
    status: status ?? this.status,
    phone: phone ?? this.phone,
    markerColor: markerColor ?? this.markerColor,
    markerIcon: markerIcon ?? this.markerIcon,
    owner: owner ?? this.owner,
    isFavorite: isFavorite ?? this.isFavorite,
    isVisited: isVisited ?? this.isVisited,
  );

  factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    type: json["type"],
    title: json["title"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    image: json["image"],
    startDate: json["start_date"] == null
        ? null
        : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    isFree: json["is_free"],
    entryFee: json["entry_fee"],
    capacity: json["capacity"],
    status: json["status"],
    phone: json["phone"],
    markerColor: json["marker_color"],
    markerIcon: json["marker_icon"],
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
    isFavorite: json["is_favorite"],
    isVisited: json["is_visited"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "latitude": latitude,
    "longitude": longitude,
    "image": image,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "is_free": isFree,
    "entry_fee": entryFee,
    "capacity": capacity,
    "status": status,
    "phone": phone,
    "marker_color": markerColor,
    "marker_icon": markerIcon,
    "owner": owner?.toJson(),
    "is_favorite": isFavorite,
    "is_visited": isVisited,
  };
}

class Owner {
  String? name;
  String? address;
  String? phone;
  String? avatar;

  Owner({this.name, this.address, this.phone, this.avatar});

  Owner copyWith({
    String? name,
    String? address,
    String? phone,
    String? avatar,
  }) => Owner(
    name: name ?? this.name,
    address: address ?? this.address,
    phone: phone ?? this.phone,
    avatar: avatar ?? this.avatar,
  );

  factory Owner.fromRawJson(String str) => Owner.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    name: json["name"],
    address: json["address"],
    phone: json["phone"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "phone": phone,
    "avatar": avatar,
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
