import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/features/visited/data/visited_data/api.dart';
import 'package:size_matter_swt/features/visited/model/visited_model.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/networks/rx_base.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/networks/stream_cleaner.dart';

final class GetVisitedRx extends RxResponseInt {
  final api = GetVisitedApi.instance;

  GetVisitedRx({required super.empty, required super.dataFetcher});

  ValueStream get fillData => dataFetcher.stream;

  Future<bool> fetchVisitedData() async {
    try {
      Map resdata = await api.getVisitedData();
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
    VisitedModel res = VisitedModel.fromJson(data as Map<String, dynamic>);

    // ✅ Step 1: Update sink immediately with raw data
    dataFetcher.sink.add(res);

    final visitedList = res.data?.visited ?? [];
    if (visitedList.isEmpty) return true;

    // ✅ Step 2: Background Geocoding
    final List<Visited> updated = [];
    bool hasChanges = false;

    for (final v in visitedList) {
      final lat = v.item?.latitude;
      final lng = v.item?.longitude;

      if (lat != null && lng != null) {
        final resolvedAddress = await _getAddressFromLatLng(lat, lng);
        if (resolvedAddress.isNotEmpty) {
          final updatedItem = v.item?.copyWith(
            resolvedAddress: resolvedAddress,
          );
          updated.add(v.copyWith(item: updatedItem));
          hasChanges = true;
          continue;
        }
      }
      updated.add(v);
    }

    if (hasChanges) {
      final updatedRes = res.copyWith(
        data: res.data?.copyWith(visited: updated),
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
