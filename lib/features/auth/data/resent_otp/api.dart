import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class ResendOtpapi {
  static final ResendOtpapi _singleton = ResendOtpapi._internal();
  ResendOtpapi._internal();
  static ResendOtpapi get instance => _singleton;

  Future<Map> postOtp(Map data) async {
    try {
      Response response = await postHttp(EndPoints.resendOtp(), data);
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
