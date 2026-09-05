import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/common/custom_toast.dart';
import 'package:size_matter_swt/features/event_list/model/events_model.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/networks/stream_cleaner.dart';
import '../../../../../../constants/app_constants.dart';
import '../../../../../../helpers/all_routes.dart';
import '../../../../../../helpers/di.dart';
import '../../../../../../networks/rx_base.dart';
import 'api.dart';

final class GetAllEventRx extends RxResponseInt {
  final api = GetAllEventApi.instance;

  GetAllEventRx({required super.empty, required super.dataFetcher});

  ValueStream<EventsModel> get fillData => 
      dataFetcher.stream as ValueStream<EventsModel>;

  Future<bool> fetchAllEvents() async {
    try {
      EventsModel resdata = await api.getAllEventData(); 
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) async { 
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        totalDataClean();
        appData.write(kKeyIsLoggedIn, false);
        NavigationService.navigateToReplacementUntil(Routes.signinScreen);
      } else {
        message = error.response?.data["message"].toString() ??
            "Something went wrong";
      }
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    customToastMessage('Error', message);
    return false;
  }
}
