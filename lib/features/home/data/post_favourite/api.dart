import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PostFavouritesApi {
  static final PostFavouritesApi _singleton = PostFavouritesApi._internal();
  PostFavouritesApi._internal();
  static PostFavouritesApi get instance => _singleton;

  Future<Map> postFavourites(Map data) async {
    try {
      Response response = await postHttp(EndPoints.postFavourites(), data);
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

  Future<Map> deleteFavourites(String id) async {
    try {
      Response response = await deleteHttp(EndPoints.deleteFavourites(id));
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