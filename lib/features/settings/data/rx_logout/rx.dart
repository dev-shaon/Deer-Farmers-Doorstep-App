// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:rxdart/streams.dart';

// import '../../../../constants/app_constants.dart';
// import '../../../../helpers/di.dart';
// import '../../../../helpers/toast.dart';
// import '../../../../networks/rx_base.dart';
// import 'api.dart';

// final class LogoutRx extends RxResponseInt<Map> {
//   LogoutRx({required super.empty, required super.dataFetcher});

//   ValueStream get collectionStream => dataFetcher.stream;
//   final api = LogoutApi.instance;

//   Future<bool> userLogout() async {
//     try {
//       final data = await api.userLogout();
//       handleSuccessWithReturn(data);
//       return true;
//     } catch (error) {
//       return handleErrorWithReturn(error);
//     }
//   }

//   @override
//   bool handleErrorWithReturn(dynamic error) {
//     if (error is DioException) {
//       ToastUtil.showErrorMessage(message: error.response!.data["message"]);
//     }
//     log(error.toString());
//     dataFetcher.sink.addError(error);
//     // throw error;
//     return false;
//   }

//   @override
//   dynamic handleSuccessWithReturn(dynamic data) {
//     appData.write(kKeyIsLoggedIn, false);
//     dataFetcher.sink.add(data);
//     return data;
//   }
// }
