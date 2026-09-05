import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:size_matter_swt/networks/dio/dio.dart';
import 'package:size_matter_swt/networks/endpoints.dart';
import 'package:size_matter_swt/networks/exception_handler/data_source.dart';

final class GetNearbyAdsApi {
  static final GetNearbyAdsApi _singleton = GetNearbyAdsApi._internal();
  GetNearbyAdsApi._internal();
  static GetNearbyAdsApi get instance => _singleton;

  Future<Map> getNearbyAds({
    required double latitude,
    required double longitude,
    double radius = 360,
  }) async {
    try {
      final formData = FormData.fromMap({
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radius': radius.toStringAsFixed(0),
      });

      final response = await postHttp(EndPoints.nearbyAds(), formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(json.encode(response.data));
        return Map<String, dynamic>.from(data as Map);
      }

      throw DataSource.DEFAULT.getFailure();
    } catch (error) {
      rethrow;
    }
  }
}
