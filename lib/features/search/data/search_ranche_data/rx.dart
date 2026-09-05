import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/di.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import 'package:size_matter_swt/features/home/model/ranche_model.dart';
import 'api.dart';

final class SearchRanchesRx extends RxResponseInt<RancheModel> {
  final api = SearchRanchesApi.instance;

  String message = "Something went wrong";

  SearchRanchesRx({required super.empty, required super.dataFetcher});

  ValueStream<RancheModel> get fillData => dataFetcher.stream;

  Future<bool> searchRanches(String query) async {
    try {
      Map resdata = await api.searchRanches(query);
      handleSuccessWithReturn(RancheModel.fromJson(Map<String, dynamic>.from(resdata)));
      return true;
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
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
        message = error.response?.data["message"].toString() ?? "Something went wrong";
      }
    }
    ToastUtil.showErrorMessage(message);
    return false;
  }
}
