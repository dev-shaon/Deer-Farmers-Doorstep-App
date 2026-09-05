import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../../../constants/app_constants.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/stream_cleaner.dart';
import 'api.dart';

final class ResendOtpapiRx extends RxResponseInt {
  final api = ResendOtpapi.instance;

  String message = "Something went wrong";

  ResendOtpapiRx({required super.empty, required super.dataFetcher});

  ValueStream get filleData => dataFetcher.stream;

  Future<bool> resend({String? email}) async {
    try {
      Map<String, dynamic> data = {"email": email};

      Map resdata = await api.postOtp(data);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    

    if (data['data']['otp'] != null) {
      data['data']['otp'].toString();

      // customToastMessage(
      //   'Success',
      //   data['message'] ?? 'OTP sent to your email',
      // );
    } else {
      log("OTP not found in response");
    }
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      if (error.response!.statusCode == 401) {
        totalDataClean();
        appData.write(kKeyIsLoggedIn, false);
        NavigationService.navigateToReplacementUntil(Routes.signinScreen);
      } else {
      }
    }
    ToastUtil.showErrorMessage(message);
    return false;
  }
}
