// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rxdart/rxdart.dart';

// import '../../../../../networks/rx_base.dart';
// import '../../../../constants/app_constants.dart';
// import '../../../../helpers/di.dart';
// import '../../../../networks/stream_cleaner.dart';
// import 'api.dart';

// final class UpdateProfileRx extends RxResponseInt<Map> {
//   final api = UpdateProfileApi.instance;//

//   UpdateProfileRx({required super.empty, required super.dataFetcher});//

//   ValueStream get getFileData => dataFetcher.stream;//

//   Future<bool> updateProfile({
//     required String name,
//     required String lName,
//     XFile? avatar,
//     String? dob,
//   }) async {
//     try {
//       final data = await api.setupProfile(
//         name: name,
//         lName: lName,
//         avatar: avatar,
//         dob: dob,
//       );
//       handleSuccessWithReturn(data);
//       return true;
//     } catch (error) {
//       return handleErrorWithReturn(error);
//     }
//   }

//   @override
//   handleErrorWithReturn(dynamic error) {
//     if (error is DioException) {
//       if (error.response!.statusCode == 401) {
//         totalDataClean();
//         appData.write(kKeyIsLoggedIn, false);
//         // NavigationService.navigateToReplacementUntil(Routes.signinRoute);
//       } else {
//         log(error.response!.data["message"]);
//       }
//     }
//     log(error.toString());
//     dataFetcher.sink.addError(error);
//     // throw error;
//     return false;
//   }
// }
