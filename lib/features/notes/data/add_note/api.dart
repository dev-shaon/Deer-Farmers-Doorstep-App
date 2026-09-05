import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../../networks/dio/dio.dart';
import '../../../../../networks/endpoints.dart';
import '../../../../../networks/exception_handler/data_source.dart';

final class AutoSaveNoteApi {
  static final AutoSaveNoteApi _singleton = AutoSaveNoteApi._internal();
  AutoSaveNoteApi._internal();
  static AutoSaveNoteApi get instance => _singleton;

  Future<Map> autoSaveNoteApi(Map data) async {
    try {
      Response response = await postHttp(EndPoints.autoSaveNotes(), data);
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