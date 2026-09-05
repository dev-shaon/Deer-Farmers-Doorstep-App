import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class DeleteNotesApi {
  static final DeleteNotesApi _singleton = DeleteNotesApi._internal();
  DeleteNotesApi._internal();
  static DeleteNotesApi get instance => _singleton;

  Future<Map> deleteNotes(String id) async {
    try {
      Response response = await deleteHttp(EndPoints.deleteNotes(id));
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