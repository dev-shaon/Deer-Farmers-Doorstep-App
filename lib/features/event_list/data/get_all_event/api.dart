import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:size_matter_swt/features/event_list/model/events_model.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetAllEventApi {
  static final GetAllEventApi _singleton = GetAllEventApi._internal();
  GetAllEventApi._internal();
  static GetAllEventApi get instance => GetAllEventApi._singleton;

  Future<EventsModel> getAllEventData() async { 
    try {
      Response response = await getHttp(EndPoints.getAllEvents());
      if (response.statusCode == 200) {
        Map data = json.decode(json.encode(response.data));
        return EventsModel.fromJson(data as Map<String, dynamic>);
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
}
