import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/common/custom_toast.dart';
import '../../../../../networks/rx_base.dart';
import 'api.dart';

final class AutoSaveNoteRx extends RxResponseInt {
  final api = AutoSaveNoteApi.instance;

  AutoSaveNoteRx({required super.empty, required super.dataFetcher});

  ValueStream get filleData => dataFetcher.stream;

  Future<bool> post({
    int? id,
    String? title,
    String? content,
    String? color,
  }) async {
    try {
      Map<String, dynamic> data = {
        if (id != null) "note_id": id,
        "title": title,
        "content": content,
        "color": color,
      };

      Map resdata = await api.autoSaveNoteApi(data);
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
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      message =
          error.response?.data["message"].toString() ?? "Something went wrong";
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    customToastMessage('Error', message);
    return false;
  }
}
