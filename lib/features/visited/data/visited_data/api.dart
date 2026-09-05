import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetVisitedApi {
  static final GetVisitedApi _singleton = GetVisitedApi._internal();
  GetVisitedApi._internal();
  static GetVisitedApi get instance => _singleton;

  Future<Map> getVisitedData() async {
    try {
      Response response = await getHttp(EndPoints.visited());
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