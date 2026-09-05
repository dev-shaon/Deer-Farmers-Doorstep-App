import 'dart:convert';

class LoginResponse {
  bool? success;
  String? message;
  Data? data;
  dynamic errors;
  int? code;

  LoginResponse({
    this.success,
    this.message,
    this.data,
    this.errors,
    this.code,
  });

  LoginResponse copyWith({
    bool? success,
    String? message,
    Data? data,
    dynamic errors,
    int? code,
  }) => LoginResponse(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    errors: errors ?? this.errors,
    code: code ?? this.code,
  );

  factory LoginResponse.fromRawJson(String str) =>
      LoginResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
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
  User? user;
  String? token;
  String? tokenType;
  int? expiresIn;
  bool? isNewUser;

  Data({
    this.user,
    this.token,
    this.tokenType,
    this.expiresIn,
    this.isNewUser,
  });

  Data copyWith({
    User? user,
    String? token,
    String? tokenType,
    int? expiresIn,
    bool? isNewUser,
  }) => Data(
    user: user ?? this.user,
    token: token ?? this.token,
    tokenType: tokenType ?? this.tokenType,
    expiresIn: expiresIn ?? this.expiresIn,
    isNewUser: isNewUser ?? this.isNewUser,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    token: json["token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    isNewUser: json["is_new_user"],
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "token": token,
    "token_type": tokenType,
    "expires_in": expiresIn,
    "is_new_user": isNewUser,
  };
}

class User {
  int? id;
  String? email;
  String? phone;
  String? status;
  dynamic role;
  bool? isSubscribe; // সঠিক জায়গায় আনা হয়েছে
  Profile? profile;

  User({
    this.id, 
    this.email, 
    this.phone, 
    this.status, 
    this.role, 
    this.isSubscribe, // কনস্ট্রাক্টর আপডেট করা হয়েছে
    this.profile,
  });

  User copyWith({
    int? id,
    String? email,
    String? phone,
    String? status,
    dynamic role,
    bool? isSubscribe,
    Profile? profile,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    status: status ?? this.status,
    role: role ?? this.role,
    isSubscribe: isSubscribe ?? this.isSubscribe,
    profile: profile ?? this.profile,
  );

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    phone: json["phone"],
    status: json["status"],
    role: json["role"],
    isSubscribe: json["is_subscribe"], // API এর আসল ভ্যালু ম্যাপ করবে
    profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone": phone,
    "status": status,
    "role": role,
    "is_subscribe": isSubscribe, // ডাটা হারানোর কোনো ভয় নেই এখন
    "profile": profile?.toJson(),
  };
}

class Profile {
  dynamic id;
  String? name;
  String? username;
  String? slug;
  String? avatar;

  Profile({this.id, this.name, this.username, this.slug, this.avatar});

  Profile copyWith({
    dynamic id,
    String? name,
    String? username,
    String? slug,
    String? avatar,
  }) => Profile(
    id: id ?? this.id,
    name: name ?? this.name,
    username: username ?? this.username,
    slug: slug ?? this.slug,
    avatar: avatar ?? this.avatar,
  );

  factory Profile.fromRawJson(String str) => Profile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json["id"],
    name: json["name"],
    username: json["username"],
    slug: json["slug"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "username": username,
    "slug": slug,
    "avatar": avatar,
  };
}