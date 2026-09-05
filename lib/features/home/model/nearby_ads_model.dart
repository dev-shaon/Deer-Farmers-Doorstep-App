import 'dart:convert';

class NearbyAdsModel {
  bool? success;
  String? message;
  NearbyAdsData? data;
  dynamic errors;
  int? code;

  NearbyAdsModel({
    this.success,
    this.message,
    this.data,
    this.errors,
    this.code,
  });

  NearbyAdsModel copyWith({
    bool? success,
    String? message,
    NearbyAdsData? data,
    dynamic errors,
    int? code,
  }) => NearbyAdsModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    errors: errors ?? this.errors,
    code: code ?? this.code,
  );

  NearbyAd? get firstAd {
    final ads = data?.ads;
    if (ads == null || ads.isEmpty) return null;
    return ads.first;
  }

  factory NearbyAdsModel.fromRawJson(String str) =>
      NearbyAdsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearbyAdsModel.fromJson(Map<String, dynamic> json) => NearbyAdsModel(
    success: json['success'] as bool?,
    message: json['message'] as String?,
    data: json['data'] == null
        ? null
        : NearbyAdsData.fromJson(Map<String, dynamic>.from(json['data'])),
    errors: json['errors'],
    code: _toInt(json['code']),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
    'errors': errors,
    'code': code,
  };
}

class NearbyAdsData {
  int? count;
  List<NearbyAd>? ads;

  NearbyAdsData({this.count, this.ads});

  NearbyAdsData copyWith({int? count, List<NearbyAd>? ads}) =>
      NearbyAdsData(count: count ?? this.count, ads: ads ?? this.ads);

  factory NearbyAdsData.fromRawJson(String str) =>
      NearbyAdsData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearbyAdsData.fromJson(Map<String, dynamic> json) => NearbyAdsData(
    count: _toInt(json['count']),
    ads: json['ads'] == null
        ? <NearbyAd>[]
        : List<NearbyAd>.from(
            (json['ads'] as List).map(
              (x) => NearbyAd.fromJson(Map<String, dynamic>.from(x)),
            ),
          ),
  );

  Map<String, dynamic> toJson() => {
    'count': count,
    'ads': ads == null ? [] : List<dynamic>.from(ads!.map((x) => x.toJson())),
  };
}

class NearbyAd {
  int? id;
  String? title;
  String? subtitle;
  String? image;
  String? ctaLabel;
  double? distanceMeters;
  String? distanceLabel;
  double? triggerLatitude;
  double? triggerLongitude;
  double? radiusMeters;
  dynamic linkedPlace;

  NearbyAd({
    this.id,
    this.title,
    this.subtitle,
    this.image,
    this.ctaLabel,
    this.distanceMeters,
    this.distanceLabel,
    this.triggerLatitude,
    this.triggerLongitude,
    this.radiusMeters,
    this.linkedPlace,
  });

  NearbyAd copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? image,
    String? ctaLabel,
    double? distanceMeters,
    String? distanceLabel,
    double? triggerLatitude,
    double? triggerLongitude,
    double? radiusMeters,
    dynamic linkedPlace,
  }) => NearbyAd(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    image: image ?? this.image,
    ctaLabel: ctaLabel ?? this.ctaLabel,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    distanceLabel: distanceLabel ?? this.distanceLabel,
    triggerLatitude: triggerLatitude ?? this.triggerLatitude,
    triggerLongitude: triggerLongitude ?? this.triggerLongitude,
    radiusMeters: radiusMeters ?? this.radiusMeters,
    linkedPlace: linkedPlace ?? this.linkedPlace,
  );

  factory NearbyAd.fromRawJson(String str) =>
      NearbyAd.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NearbyAd.fromJson(Map<String, dynamic> json) => NearbyAd(
    id: _toInt(json['id']),
    title: json['title']?.toString(),
    subtitle: json['subtitle']?.toString(),
    image: json['image']?.toString(),
    ctaLabel: json['cta_label']?.toString(),
    distanceMeters: _toDouble(json['distance_m']),
    distanceLabel: json['distance_label']?.toString(),
    triggerLatitude: _toDouble(json['trigger_latitude']),
    triggerLongitude: _toDouble(json['trigger_longitude']),
    radiusMeters: _toDouble(json['radius_meters']),
    linkedPlace: json['linked_place'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'image': image,
    'cta_label': ctaLabel,
    'distance_m': distanceMeters,
    'distance_label': distanceLabel,
    'trigger_latitude': triggerLatitude,
    'trigger_longitude': triggerLongitude,
    'radius_meters': radiusMeters,
    'linked_place': linkedPlace,
  };
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
