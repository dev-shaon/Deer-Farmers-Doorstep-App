import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/common/custom_toast.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/networks/stream_cleaner.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class DeleteNotificationRx extends RxResponseInt {
  final api = DeleteNotificationApi.instance;

  DeleteNotificationRx({required super.empty, required super.dataFetcher});

  ValueStream<Map<String, dynamic>> get fillData =>
      dataFetcher.stream as ValueStream<Map<String, dynamic>>;

  Future<bool> deleteNotificationApi({required String id}) async {
    try {
      Map<String, dynamic> resdata = await api.deleteNotification(id);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  Future<bool> handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  Future<bool> handleErrorWithReturn(error) async {
    String message = 'Something went wrong';
    log(error.toString());

    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        totalDataClean();
        appData.write(kKeyIsLoggedIn, false);
        NavigationService.navigateToReplacementUntil(Routes.signinScreen);
      } else {
        message = error.response?.data["message"]?.toString() ??
            'Something went wrong';
      }
      if (error.type == DioExceptionType.connectionError) {
        message = 'Check Your Network Connection';
      }
    }

    customToastMessage('Error', message);
    return false;
  }
}
