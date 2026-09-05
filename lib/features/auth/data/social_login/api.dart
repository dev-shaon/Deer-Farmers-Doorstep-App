import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:size_matter_swt/features/auth/model/login_response.dart';

import '/networks/endpoints.dart';
import '../../../../../../networks/dio/dio.dart';
import '../../../../../../networks/exception_handler/data_source.dart';

final class SocialLoginApi {
  static final SocialLoginApi _singleton = SocialLoginApi._internal();
  SocialLoginApi._internal();
  static SocialLoginApi get instance => _singleton;

  Future<LoginResponse> socialLogin({
    required String token,
    required String provider,
  }) async {
    try {
      Map data = {"access_token": token, "provider": provider};

      Response response = await postHttp(EndPoints.socialLogin(), data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = LoginResponse.fromRawJson(json.encode(response.data));
        return data;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
