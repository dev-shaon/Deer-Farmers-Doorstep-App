import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:size_matter_swt/networks/dio/dio.dart';
import 'package:size_matter_swt/networks/endpoints.dart';
import 'package:size_matter_swt/networks/exception_handler/data_source.dart';
 
final class ChangePasswordApi {
  static final ChangePasswordApi _singleton = ChangePasswordApi._internal();
  ChangePasswordApi._internal();
  static ChangePasswordApi get instance => _singleton;
 
  Future<Map> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      Map data = {
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      };
      Response response = await postHttp(EndPoints.changepassword(), data);
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