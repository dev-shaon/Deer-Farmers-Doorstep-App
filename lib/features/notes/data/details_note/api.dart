import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class NoteDetailsApi {
  static final NoteDetailsApi _singleton = NoteDetailsApi._internal();
  NoteDetailsApi._internal();
  static NoteDetailsApi get instance => _singleton;

  Future<Map> getDetailsNoteData(String id) async {
    try {
      Response response = await getHttp(EndPoints.showNotes(id));
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