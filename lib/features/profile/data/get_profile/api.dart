import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:size_matter_swt/networks/dio/dio.dart';
import 'package:size_matter_swt/networks/endpoints.dart';
import 'package:size_matter_swt/networks/exception_handler/data_source.dart';

 
final class GetProfileApi {
  static final GetProfileApi _singleton = GetProfileApi._internal();
  GetProfileApi._internal();
  static GetProfileApi get instance => _singleton;
 
  Future<Map> getProfile() async {
    try {
      Response response = await getHttp(EndPoints.userDetails());
      if (response.statusCode == 200) {
        return json.decode(json.encode(response.data));
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}