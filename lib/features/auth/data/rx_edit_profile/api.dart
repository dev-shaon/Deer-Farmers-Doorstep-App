// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../../../networks/dio/dio.dart';
// import '../../../../../networks/endpoints.dart';
// import '../../../../../networks/exception_handler/data_source.dart';

// final class UpdateProfileApi {
//   static final UpdateProfileApi _singleton = UpdateProfileApi._internal();
//   UpdateProfileApi._internal();

//   static UpdateProfileApi get instance => _singleton;

//   Future<Map> setupProfile({
//     required String name,
//     required String lName,
//     XFile? avatar,
//     String? dob,
//   }) async {
//     try {
//       FormData data = FormData.fromMap({
//         "name": name,
//         "last_name": lName,
//         'dob': dob,
//       });

//       if (avatar != null && await File(avatar.path).exists()) {
//         data.files.add(
//           MapEntry('avatar', await MultipartFile.fromFile(avatar.path)),
//         );
//       }

//       Response response = await postHttp(EndPoints.editProfile(), data);

//       if (response.statusCode == 200) {
//         final data = json.decode(json.encode(response.data));
//         return data;
//       } else {
//         throw DataSource.DEFAULT.getFailure();
//       }
//     } catch (error) {
//       rethrow;
//     }
//   }
// }
