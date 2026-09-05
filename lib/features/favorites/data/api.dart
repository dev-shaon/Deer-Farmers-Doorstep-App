import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class GetFavouritesApi {
  static final GetFavouritesApi _singleton = GetFavouritesApi._internal();
  GetFavouritesApi._internal();
  static GetFavouritesApi get instance => _singleton;

  Future<Map> getFavoritesData() async {
    try {
      Response response = await getHttp(EndPoints.favorites());
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