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
import 'package:size_matter_swt/features/event_list/model/events_model.dart';
import 'api.dart';

final class SearchEventsRx extends RxResponseInt<EventsModel> {
  final api = SearchEventsApi.instance;

  String message = "Something went wrong";

  SearchEventsRx({required super.empty, required super.dataFetcher});

  ValueStream<EventsModel> get fillData => dataFetcher.stream;

  Future<bool> searchEvents(String query) async {
    try {
      Map resdata = await api.searchEvents(query);
      handleSuccessWithReturn(EventsModel.fromJson(Map<String, dynamic>.from(resdata)));
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
