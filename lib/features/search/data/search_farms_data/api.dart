import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class SearchFarmsApi {
  static final SearchFarmsApi _singleton = SearchFarmsApi._internal();
  SearchFarmsApi._internal();
  static SearchFarmsApi get instance => _singleton;

  Future<Map> searchFarms(String query) async {
    try {
      Response response = await getHttp(EndPoints.searchFarms(query));
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
