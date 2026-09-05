// import 'dart:convert';
// import 'dart:developer';

// import 'package:dio/dio.dart';

// import '../../../../networks/dio/dio.dart';
// import '../../../../networks/endpoints.dart';
// import '../../../../networks/exception_handler/data_source.dart';
// import '../../model/profile_response.dart';

// final class GetProfileApi {
//   static final GetProfileApi _singleton = GetProfileApi._internal();
//   GetProfileApi._internal();

//   static GetProfileApi get instance => _singleton;

//   Future<ProfileResponse> getUserProfile() async {
//     try {
//       Response response = await getHttp(EndPoints.userProfile());
//       if (response.statusCode == 200) {
//         final data = ProfileResponse.fromRawJson(json.encode(response.data));
//         return data;
//       } else {
//         log('Error: ${response.statusCode}');
//         throw DataSource.DEFAULT.getFailure();
//       }
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
