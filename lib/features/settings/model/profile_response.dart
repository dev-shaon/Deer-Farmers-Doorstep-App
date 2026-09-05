import 'dart:convert';

class ProfileResponse {
  bool? status;
  String? message;
  int? code;
  Data? data;

  ProfileResponse({this.status, this.message, this.code, this.data});

  ProfileResponse copyWith({
    bool? status,
    String? message,
    int? code,
    Data? data,
  }) => ProfileResponse(
    status: status ?? this.status,
    message: message ?? this.message,
    code: code ?? this.code,
    data: data ?? this.data,
  );

  factory ProfileResponse.fromRawJson(String str) =>
      ProfileResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  dynamic name;
  dynamic lastName;
  String? phoneNumber;
  String? username;
  String? slug;
  dynamic dob;
  String? email;
  dynamic avatar;
  dynamic redeemCode;
  bool? isOnline;
  int? balance;

  Data({
    this.id,
    this.name,
    this.lastName,
    this.phoneNumber,
    this.username,
    this.slug,
    this.dob,
    this.email,
    this.avatar,
    this.redeemCode,
    this.isOnline,
    this.balance,
  });

  Data copyWith({
    int? id,
    dynamic name,
    dynamic lastName,
    String? phoneNumber,
    String? username,
    String? slug,
    dynamic dob,
    String? email,
    dynamic avatar,
    dynamic redeemCode,
    bool? isOnline,
    int? balance,
  }) => Data(
    id: id ?? this.id,
    name: name ?? this.name,
    lastName: lastName ?? this.lastName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    username: username ?? this.username,
    slug: slug ?? this.slug,
    dob: dob ?? this.dob,
    email: email ?? this.email,
    avatar: avatar ?? this.avatar,
    redeemCode: redeemCode ?? this.redeemCode,
    isOnline: isOnline ?? this.isOnline,
    balance: balance ?? this.balance,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    lastName: json["last_name"],
    phoneNumber: json["phone_number"],
    username: json["username"],
    slug: json["slug"],
    dob: json["dob"],
    email: json["email"],
    avatar: json["avatar"],
    redeemCode: json["redeem_code"],
    isOnline: json["is_online"],
    balance: json["balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "last_name": lastName,
    "phone_number": phoneNumber,
    "username": username,
    "slug": slug,
    "dob": dob,
    "email": email,
    "avatar": avatar,
    "redeem_code": redeemCode,
    "is_online": isOnline,
    "balance": balance,
  };
}
