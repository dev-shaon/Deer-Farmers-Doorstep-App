// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';

import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/features/auth/data/rx_signup_verify/api.dart';
import 'package:size_matter_swt/features/subscription/data/subscription_service.dart';
import 'package:size_matter_swt/helpers/toast.dart';

import '../../../../../../networks/rx_base.dart';
import '../../../../../../constants/app_constants.dart';
import '../../../../../../helpers/di.dart';
import '../../../../../../networks/dio/dio.dart';

final class VerifySignupOtpRx extends RxResponseInt<Map> {
  String? errorMessage;
  String? savePass;
  String? otp;
  final api = SignUpVerifyApi.instance;

  VerifySignupOtpRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> otpverify({required String email, required String otp}) async {
    try {
      final data = await api.otpverify(email: email, otp: otp);

      // Save token and login state
      if (data['data'] != null && data['data']['token'] != null) {
        appData.write(kKeyAccessToken, data['data']['token'] ?? "");
        appData.write(
          kKeyUserId,
          data['data']['user']?['id']?.toString() ?? "",
        );
        appData.write(kKeyIsLoggedIn, true);
        DioSingleton.instance.update(data['data']['token'] ?? "");
        SubscriptionService.logIn(
          data['data']['user']?['id']?.toString() ?? "",
        );
      }

      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleErrorWithReturn(error) {
    if (error is DioException) {
      if (error.response!.statusCode == 400) {
        ToastUtil.showLongToast(errorMessage = error.response!.data['message']);
      } else if (error.response!.data['code'] == 403) {
        ToastUtil.showLongToast(errorMessage = error.response!.data['message']);
      } else {
        ToastUtil.showLongToast(errorMessage = error.response!.data['message']);
      }
    }
    // log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}
