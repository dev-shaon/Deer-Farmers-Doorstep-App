// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:rxdart/streams.dart';

// import '../../../../../networks/rx_base.dart';
// import '../../../../constants/app_constants.dart';
// import '../../../../helpers/di.dart';
// import '../../../../helpers/toast.dart';
// import '../../../../networks/stream_cleaner.dart';
// import '../../model/profile_response.dart';
// import 'api.dart';

// final class GetProfileRx extends RxResponseInt<ProfileResponse> {
//   GetProfileRx({required super.empty, required super.dataFetcher});

//   ValueStream get getUserProfileStream => dataFetcher.stream;
//   final api = GetProfileApi.instance;

//   Future<bool> getUserProfile() async {
//     try {
//       final data = await api.getUserProfile();
//       handleSuccessWithReturn(data);

//       return true;
//     } catch (error) {
//       return handleErrorWithReturn(error);
//     }
//   }

//   @override
//   handleSuccessWithReturn(ProfileResponse data) {
//     var userId = data.data!.id;
//     log("User ID IS ==========> $userId");
//     // appData.write(kKeyRole, data.data!.role!);
//     // appData.write(kKeyIsLoggedIn, true);
//     // appData.write(KKeyUserId, userId);

//     // String token = appData.read(kKeyAccessToken);

//     dataFetcher.sink.add(data);
//     return data;
//   }

//   @override
//   handleErrorWithReturn(dynamic error) {
//     if (error is DioException) {
//       if (error.response!.statusCode == 401) {
//         totalDataClean();
//         appData.write(kKeyIsLoggedIn, false);
//         // NavigationService.navigateToReplacementUntil(Routes.signinRoute);
//       } else {
//         ToastUtil.showErrorMessage(message: error.response!.data["message"]);
//       }
//     }
//     log(error.toString());
//     dataFetcher.sink.addError(error);
//     // throw error;
//     return false;
//   }
// }
