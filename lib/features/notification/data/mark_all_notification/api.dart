import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:size_matter_swt/networks/dio/dio.dart';
import 'package:size_matter_swt/networks/endpoints.dart';
import 'package:size_matter_swt/networks/exception_handler/data_source.dart';

final class MarkAllNotificationApi {
  static final MarkAllNotificationApi _singleton = MarkAllNotificationApi._internal();
  MarkAllNotificationApi._internal();
  static MarkAllNotificationApi get instance => _singleton;

  Future<Map> markAllNotificationFun(Map data) async {
    try {
      Response response = await postHttp(EndPoints.markAllNotification(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map data = json.decode(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}