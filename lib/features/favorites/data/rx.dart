import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/features/favorites/model/favourite_model.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import '../../../../../networks/rx_base.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../networks/stream_cleaner.dart';
import 'api.dart';

final class GetFavouriteRx extends RxResponseInt {
  final api = GetFavouritesApi.instance;

  GetFavouriteRx({required super.empty, required super.dataFetcher});

  ValueStream get fillData => dataFetcher.stream;

  Future<bool> fetchFavoritesData() async {
    try {
      Map resdata = await api.getFavoritesData();
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        "https://maps.googleapis.com/maps/api/geocode/json",
        queryParameters: {'latlng': '$lat,$lng', 'key': googleApiKeyy},
      );
      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final results = response.data['results'] as List;
        if (results.isNotEmpty) {
          return results[0]['formatted_address'] ?? '';
        }
      }
    } catch (e) {
      log("Geocode Error: $e");
    }
    return '';
  }

  @override
  handleSuccessWithReturn(data) async {
    FavouriteModel res = FavouriteModel.fromJson(data as Map<String, dynamic>);

    dataFetcher.sink.add(res);

    final favorites = res.data?.favorites ?? [];
    if (favorites.isEmpty) return true;

    final List<Favorite> updatedFavorites = [];
    bool hasChanges = false;

    for (var favorite in favorites) {
      final lat = favorite.item?.latitude;
      final lng = favorite.item?.longitude;

      if (lat != null && lng != null) {
        final resolvedAddress = await _getAddressFromLatLng(lat, lng);
        if (resolvedAddress.isNotEmpty) {
          final updatedItem = favorite.item?.copyWith(
            resolvedAddress: resolvedAddress,
          );
          updatedFavorites.add(favorite.copyWith(item: updatedItem));
          hasChanges = true;
          continue;
        }
      }
      updatedFavorites.add(favorite);
    }

    if (hasChanges) {
      final updatedRes = res.copyWith(
        data: res.data?.copyWith(favorites: updatedFavorites),
      );
      dataFetcher.sink.add(updatedRes);
    }

    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        totalDataClean();
        appData.write(kKeyIsLoggedIn, false);
        NavigationService.navigateToReplacementUntil(Routes.signinScreen);
      } else {
        message =
            error.response?.data["message"].toString() ??
            "Something went wrong";
      }
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    ToastUtil.showErrorMessage(message);
    return false;
  }
}
