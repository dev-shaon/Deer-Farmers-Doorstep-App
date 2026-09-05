import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class PolicyApi {
  static final PolicyApi _singleton = PolicyApi._internal();
  PolicyApi._internal();
  static PolicyApi get instance => _singleton;

  Future<Map> getfunctionNameData() async {
    try {
      Response response = await getHttp(EndPoints.policy());
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
