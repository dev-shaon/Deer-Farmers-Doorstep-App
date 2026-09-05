import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetRanchesApi {
  static final GetRanchesApi _singleton = GetRanchesApi._internal();
  GetRanchesApi._internal();
  static GetRanchesApi get instance => _singleton;

  Future<Map> getRanchesData({int page = 1}) async {
    try {
      Response response = await getHttp("${EndPoints.ranches()}?page=$page");
      if (response.statusCode == 200) {
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