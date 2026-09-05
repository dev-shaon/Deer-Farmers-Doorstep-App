import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class SearchRanchesApi {
  static final SearchRanchesApi _singleton = SearchRanchesApi._internal();
  SearchRanchesApi._internal();
  static SearchRanchesApi get instance => _singleton;

  Future<Map> searchRanches(String query) async {
    try {
      Response response = await getHttp(EndPoints.searchRanches(query));
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
