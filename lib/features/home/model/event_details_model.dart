import 'dart:convert';

class EventDetailsModel {
  bool? success;
  String? message;
  Data? data;
  dynamic errors;
  int? code;

  EventDetailsModel({
    this.success,
    this.message,
    this.data,
    this.errors,
    this.code,
  });

  EventDetailsModel copyWith({
    bool? success,
    String? message,
    Data? data,
    dynamic errors,
    int? code,
  }) => EventDetailsModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    errors: errors ?? this.errors,
    code: code ?? this.code,
  );

  factory EventDetailsModel.fromRawJson(String str) =>
      EventDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) =>
      EventDetailsModel(
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
  Event? event;

  Data({this.event});

  Data copyWith({Event? event}) => Data(event: event ?? this.event);

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(event: json["event"] == null ? null : Event.fromJson(json["event"]));

  Map<String, dynamic> toJson() => {"event": event?.toJson()};
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
  String? image;
  DateTime? startDate;
  DateTime? endDate;
  dynamic isFree;
  int? entryFee;
  dynamic capacity;
  String? status;
  String? phone;
  String? markerColor;
  String? markerIcon;
  Owner? owner;
  bool? isFavorite;
  bool? isVisited;
  String? description;
  String? email;
  String? website;
  dynamic linkedPlace;
  List<Media>? media;

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
    this.description,
    this.email,
    this.website,
    this.linkedPlace,
    this.media,
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
    String? image,
    DateTime? startDate,
    DateTime? endDate,
    dynamic isFree,
    int? entryFee,
    dynamic capacity,
    String? status,
    String? phone,
    String? markerColor,
    String? markerIcon,
    Owner? owner,
    bool? isFavorite,
    bool? isVisited,
    String? description,
    String? email,
    String? website,
    dynamic linkedPlace,
    List<Media>? media,
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
    description: description ?? this.description,
    email: email ?? this.email,
    website: website ?? this.website,
    linkedPlace: linkedPlace ?? this.linkedPlace,
    media: media ?? this.media,
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
    description: json["description"],
    email: json["email"],
    website: json["website"],
    linkedPlace: json["linked_place"],
    media: json["media"] == null
        ? []
        : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
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
    "description": description,
    "email": email,
    "website": website,
    "linked_place": linkedPlace,
    "media": media == null
        ? []
        : List<dynamic>.from(media!.map((x) => x.toJson())),
  };
}

class Media {
  int? eventsId;
  String? filePath;
  String? fileName;
  String? mimeType;
  int? fileSize;
  String? mediaType;
  dynamic thumbnailPath;
  dynamic durationSeconds;
  dynamic caption;
  bool? isCover;
  int? sortOrder;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? url;
  dynamic thumbnailUrl;

  Media({
    this.eventsId,
    this.filePath,
    this.fileName,
    this.mimeType,
    this.fileSize,
    this.mediaType,
    this.thumbnailPath,
    this.durationSeconds,
    this.caption,
    this.isCover,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.url,
    this.thumbnailUrl,
  });

  Media copyWith({
    int? eventsId,
    String? filePath,
    String? fileName,
    String? mimeType,
    int? fileSize,
    String? mediaType,
    dynamic thumbnailPath,
    dynamic durationSeconds,
    dynamic caption,
    bool? isCover,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? url,
    dynamic thumbnailUrl,
  }) => Media(
    eventsId: eventsId ?? this.eventsId,
    filePath: filePath ?? this.filePath,
    fileName: fileName ?? this.fileName,
    mimeType: mimeType ?? this.mimeType,
    fileSize: fileSize ?? this.fileSize,
    mediaType: mediaType ?? this.mediaType,
    thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    caption: caption ?? this.caption,
    isCover: isCover ?? this.isCover,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    url: url ?? this.url,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
  );

  factory Media.fromRawJson(String str) => Media.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    eventsId: json["events_id"],
    filePath: json["file_path"],
    fileName: json["file_name"],
    mimeType: json["mime_type"],
    fileSize: json["file_size"],
    mediaType: json["media_type"],
    thumbnailPath: json["thumbnail_path"],
    durationSeconds: json["duration_seconds"],
    caption: json["caption"],
    isCover: json["is_cover"],
    sortOrder: json["sort_order"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    url: json["url"],
    thumbnailUrl: json["thumbnail_url"],
  );

  Map<String, dynamic> toJson() => {
    "events_id": eventsId,
    "file_path": filePath,
    "file_name": fileName,
    "mime_type": mimeType,
    "file_size": fileSize,
    "media_type": mediaType,
    "thumbnail_path": thumbnailPath,
    "duration_seconds": durationSeconds,
    "caption": caption,
    "is_cover": isCover,
    "sort_order": sortOrder,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "url": url,
    "thumbnail_url": thumbnailUrl,
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
