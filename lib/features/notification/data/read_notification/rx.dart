import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/common/custom_toast.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class ReadNotificationRx extends RxResponseInt<Map<String, dynamic>> {
  final api = ReadNotificationApi.instance;

  ReadNotificationRx({required super.empty, required super.dataFetcher});

  ValueStream<Map<String, dynamic>> get filledData => dataFetcher.stream;

  Future<bool> readNotificationFun({required String id}) async {
    try {
      Map<String, dynamic> resdata = await api.readNotificationApi(id: id);
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