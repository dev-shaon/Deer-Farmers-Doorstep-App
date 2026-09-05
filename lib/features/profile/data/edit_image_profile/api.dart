import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:size_matter_swt/networks/dio/dio.dart';
import 'package:size_matter_swt/networks/endpoints.dart';
import 'package:size_matter_swt/networks/exception_handler/data_source.dart';

 
final class ProfileImageApi {
  static final ProfileImageApi _singleton = ProfileImageApi._internal();
  ProfileImageApi._internal();
  static ProfileImageApi get instance => _singleton;
 
  Future<Map> updateAvatar({required File image}) async {
    try {
      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });
 
      Response response = await postHttp(EndPoints.updateAvatar(), formData);
 
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(json.encode(response.data));
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;
    }
  }
 
}