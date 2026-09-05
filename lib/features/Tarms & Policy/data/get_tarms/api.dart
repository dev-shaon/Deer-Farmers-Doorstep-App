import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class TermsApi {
  static final TermsApi _singleton = TermsApi._internal();
  TermsApi._internal();
  static TermsApi get instance => _singleton;

  Future<Map> getTermsData() async {
    try {
      Response response = await getHttp(EndPoints.terms());
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
