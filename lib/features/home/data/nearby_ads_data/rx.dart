import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/features/home/model/nearby_ads_model.dart';
import 'package:size_matter_swt/networks/rx_base.dart';

import 'api.dart';

final class GetNearbyAdsRx extends RxResponseInt<NearbyAdsModel> {
  final api = GetNearbyAdsApi.instance;

  GetNearbyAdsRx({required super.empty, required super.dataFetcher});

  ValueStream<NearbyAdsModel> get fillData => dataFetcher.stream;

  Future<NearbyAd?> fetchFirstNearbyAd({
    required double latitude,
    required double longitude,
    double radius = 360,
  }) async {
    try {
      final responseData = await api.getNearbyAds(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );

      final model = NearbyAdsModel.fromJson(
        Map<String, dynamic>.from(responseData),
      );

      dataFetcher.sink.add(model);
      return model.firstAd;
    } catch (error) {
      _logError(error);
      return null;
    }
  }

  void _logError(Object error) {
    var message = 'Something went wrong';

    if (error is DioException) {
      message =
          error.response?.data['message']?.toString() ?? 'Something went wrong';
      if (error.type == DioExceptionType.connectionError) {
        message = 'Check your network connection';
      }
    }

    log('GetNearbyAdsRx error: $message | $error');
  }
}
