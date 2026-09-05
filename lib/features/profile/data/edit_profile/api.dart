import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';
 
final class UpdateProfileApi {
  static final UpdateProfileApi _singleton = UpdateProfileApi._internal();
  UpdateProfileApi._internal();
  static UpdateProfileApi get instance => _singleton;
 
  Future<Map> updateProfile({
    required String name,
    String? username,
    String? biography,
    String? tagline,
    String? phone, 
  }) async {
    try {
      Map data = {
        "name": name,
        if (username != null) "username": username,
        if (biography != null) "biography": biography,
        if (tagline != null) "tagline": tagline,
        if (phone != null) "phone": phone, 
      };
 
      Response response = await postHttp(EndPoints.updateprofile(), data);
 
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(json.encode(response.data));
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}