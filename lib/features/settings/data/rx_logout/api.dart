// import 'dart:convert';
// import 'dart:developer';

// import 'package:dio/dio.dart';

// import '../../../../networks/dio/dio.dart';
// import '../../../../networks/endpoints.dart';
// import '../../../../networks/exception_handler/data_source.dart';

// final class LogoutApi {
//   static final LogoutApi _singleton = LogoutApi._internal();
//   LogoutApi._internal();

//   static LogoutApi get instance => _singleton;

//   Future<Map> userLogout() async {
//     try {
//       Response response = await postHttp(EndPoints.logout());
//       if (response.statusCode == 200) {
//         final data = json.decode(json.encode(response.data));
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
