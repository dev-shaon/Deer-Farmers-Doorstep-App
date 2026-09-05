import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class NotificationApi {
  static final NotificationApi _singleton = NotificationApi._internal();
  NotificationApi._internal();
  static NotificationApi get instance => _singleton;

  Future<Map<String, dynamic>> getNotificationData() async {
    try {
      Response response = await getHttp(EndPoints.notifications());
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}