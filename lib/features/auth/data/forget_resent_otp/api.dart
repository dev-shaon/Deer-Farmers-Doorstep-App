import 'dart:convert';

import 'package:dio/dio.dart';

import '/networks/endpoints.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class ResendForgotOtpApi {  
  static final ResendForgotOtpApi _singleton = ResendForgotOtpApi._internal();
  ResendForgotOtpApi._internal();
  static ResendForgotOtpApi get instance => _singleton;

  Future<Map> resendOtp({required String email}) async {
    try {
      Map data = {"email": email};
      Response response = await postHttp(EndPoints.resendForgotOtp(), data);
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
