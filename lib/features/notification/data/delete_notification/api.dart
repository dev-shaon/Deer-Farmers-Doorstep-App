import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class DeleteNotificationApi {
  static final DeleteNotificationApi _singleton =
      DeleteNotificationApi._internal();
  DeleteNotificationApi._internal();
  static DeleteNotificationApi get instance => _singleton;

  Future<Map<String, dynamic>> deleteNotification(String id) async {
    try {
      Response response =
          await deleteHttp(EndPoints.deleteNotification(id), {});
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