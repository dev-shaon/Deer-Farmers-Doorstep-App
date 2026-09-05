import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/common/custom_toast.dart';
import 'package:size_matter_swt/networks/dio/dio.dart';
import 'package:size_matter_swt/networks/endpoints.dart';
import 'package:size_matter_swt/networks/exception_handler/data_source.dart';
import '../../../../../networks/rx_base.dart';

final class MarkAllNotificationRx extends RxResponseInt {
  final api = MarkAllNotificationApi.instance;

  MarkAllNotificationRx({required super.empty, required super.dataFetcher});

  ValueStream<Map> get filledData => dataFetcher.stream as ValueStream<Map>;

  Future<bool> post() async {
    try {
      Map resdata = await api.markAllNotificationFun({});
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
      message = error.type == DioExceptionType.connectionError
          ? "Check Your Network Connection"
          : error.response?.data["message"].toString() ?? "Something went wrong";
    }
    customToastMessage('Error', message);
    return false;
  }
}

// api.dart
final class MarkAllNotificationApi {
  static final MarkAllNotificationApi _singleton = MarkAllNotificationApi._internal();
  MarkAllNotificationApi._internal();
  static MarkAllNotificationApi get instance => _singleton;

  Future<Map> markAllNotificationFun(Map data) async {
    Response response = await postHttp(EndPoints.markAllNotification(), data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}

// instance
MarkAllNotificationRx markAllNotificationRxObj = MarkAllNotificationRx(
  empty: <String, dynamic>{},
  dataFetcher: BehaviorSubject<Map>(),
);