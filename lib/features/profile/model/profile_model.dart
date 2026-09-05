import 'dart:convert';

class Profilemodel {
    bool? success;
    String? message;
    Data? data;
    dynamic errors;
    int? code;

    Profilemodel({
        this.success,
        this.message,
        this.data,
        this.errors,
        this.code,
    });

    Profilemodel copyWith({
        bool? success,
        String? message,
        Data? data,
        dynamic errors,
        int? code,
    }) => 
        Profilemodel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
            errors: errors ?? this.errors,
            code: code ?? this.code,
        );

    factory Profilemodel.fromRawJson(String str) => Profilemodel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Profilemodel.fromJson(Map<String, dynamic> json) => Profilemodel(
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
    int? id;
    String? email;
    String? phone;
    String? status;
    String? role;
    bool? isSubscribe;
    Profile? profile;
    Subscription? subscription;

    Data({
        this.id,
        this.email,
        this.phone,
        this.status,
        this.role,
        this.isSubscribe,
        this.profile,
        this.subscription,
    });

    Data copyWith({
        int? id,
        String? email,
        String? phone,
        String? status,
        String? role,
        bool? isSubscribe,
        Profile? profile,
        Subscription? subscription,
    }) => 
        Data(
            id: id ?? this.id,
            email: email ?? this.email,
            phone: phone ?? this.phone,
            status: status ?? this.status,
            role: role ?? this.role,
            isSubscribe: isSubscribe ?? this.isSubscribe,
            profile: profile ?? this.profile,
            subscription: subscription ?? this.subscription,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        status: json["status"],
        role: json["role"],
        isSubscribe: json["is_subscribe"],
        profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        subscription: json["subscription"] == null ? null : Subscription.fromJson(json["subscription"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "status": status,
        "role": role,
        "is_subscribe": isSubscribe,
        "profile": profile?.toJson(),
        "subscription": subscription?.toJson(),
    };
}

class Profile {
    int? id;
    String? name;
    String? username;
    String? avatar;

    Profile({
        this.id,
        this.name,
        this.username,
        this.avatar,
    });

    Profile copyWith({
        int? id,
        String? name,
        String? username,
        String? avatar,
    }) => 
        Profile(
            id: id ?? this.id,
            name: name ?? this.name,
            username: username ?? this.username,
            avatar: avatar ?? this.avatar,
        );

    factory Profile.fromRawJson(String str) => Profile.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "avatar": avatar,
    };
}

class Subscription {
    int? id;
    int? userId;
    String? revenuecatAppUserId;
    String? entitlementId;
    String? productId;
    String? status;
    DateTime? expiresAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    Subscription({
        this.id,
        this.userId,
        this.revenuecatAppUserId,
        this.entitlementId,
        this.productId,
        this.status,
        this.expiresAt,
        this.createdAt,
        this.updatedAt,
    });

    Subscription copyWith({
        int? id,
        int? userId,
        String? revenuecatAppUserId,
        String? entitlementId,
        String? productId,
        String? status,
        DateTime? expiresAt,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Subscription(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            revenuecatAppUserId: revenuecatAppUserId ?? this.revenuecatAppUserId,
            entitlementId: entitlementId ?? this.entitlementId,
            productId: productId ?? this.productId,
            status: status ?? this.status,
            expiresAt: expiresAt ?? this.expiresAt,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Subscription.fromRawJson(String str) => Subscription.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        userId: json["user_id"],
        revenuecatAppUserId: json["revenuecat_app_user_id"],
        entitlementId: json["entitlement_id"],
        productId: json["product_id"],
        status: json["status"],
        expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "revenuecat_app_user_id": revenuecatAppUserId,
        "entitlement_id": entitlementId,
        "product_id": productId,
        "status": status,
        "expires_at": expiresAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
