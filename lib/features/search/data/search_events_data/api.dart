import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/endpoints.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class SearchEventsApi {
  static final SearchEventsApi _singleton = SearchEventsApi._internal();
  SearchEventsApi._internal();
  static SearchEventsApi get instance => _singleton;

  Future<Map> searchEvents(String query) async {
    try {
      Response response = await getHttp(EndPoints.searchEvents(query));
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
