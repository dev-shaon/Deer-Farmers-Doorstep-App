import 'dart:convert';

import 'package:dio/dio.dart';

import '/networks/endpoints.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class SignUpVerifyApi {
  static final SignUpVerifyApi _singleton = SignUpVerifyApi._internal();
  SignUpVerifyApi._internal();
  static SignUpVerifyApi get instance => _singleton;

  Future<Map> otpverify({required String email, required String otp}) async {
    try {
      Map data = {'email': email, "otp": otp};

      Response response = await postHttp(EndPoints.verifySignupOtp(), data);

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
