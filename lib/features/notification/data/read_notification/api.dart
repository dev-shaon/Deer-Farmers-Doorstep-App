import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class ReadNotificationApi {
  static final ReadNotificationApi _singleton = ReadNotificationApi._internal();
  ReadNotificationApi._internal();
  static ReadNotificationApi get instance => _singleton;

  Future<Map<String, dynamic>> readNotificationApi({required String id}) async {
    try {
      Response response = await postHttp(EndPoints.readNotification(id));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}