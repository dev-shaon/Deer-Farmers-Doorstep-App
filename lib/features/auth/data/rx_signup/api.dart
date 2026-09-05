import 'dart:convert';

import 'package:dio/dio.dart';

import '/networks/endpoints.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class SignupApi {
  static final SignupApi _singleton = SignupApi._internal();
  SignupApi._internal();
  static SignupApi get instance => _singleton;

  Future<Map> signup({
    required String name,
    required String email,
    required String password,
    required String passwordconfirmation,
  }) async {
    try {
      Map data = {
        "name": name,
        'email': email,
        "password": password,
        "password_confirmation": passwordconfirmation,
      };

      Response response = await postHttp(EndPoints.signup(), data);

      if (response.statusCode == 200 || response.statusCode == 201) { 
        final data = json.decode(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
