import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class EventDetailsApi {
  static final EventDetailsApi _singleton = EventDetailsApi._internal();
  EventDetailsApi._internal();
  static EventDetailsApi get instance => _singleton;

  Future<Map> getEventDetails(String id) async {
    try {
      Response response = await getHttp(EndPoints.eventDetails(id));
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
