import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/common/custom_toast.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helpers/di.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/rx_base.dart';
import '../../model/login_response.dart';
import 'api.dart';

import 'package:size_matter_swt/features/subscription/data/subscription_service.dart';

final class SocialLoginRx extends RxResponseInt<LoginResponse> {
  final api = SocialLoginApi.instance;

  SocialLoginRx({required super.empty, required super.dataFetcher});

  ValueStream get filleData => dataFetcher.stream;

  Future<bool> socialLogin({
    required String accessToken,
    required String provider,
  }) async {
    try {
      final resdata = await api.socialLogin(
        token: accessToken,
        provider: provider,
      );
      await handleSuccessWithReturn(resdata);
      return true;
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(LoginResponse data) {
    appData.write(kKeyAccessToken, data.data?.token ?? "");
    appData.write(kKeyUserId, data.data?.user?.id?.toString() ?? "");
    appData.write(kKeyIsLoggedIn, true);
    DioSingleton.instance.update(data.data?.token ?? "");
    SubscriptionService.logIn(data.data?.user?.id?.toString() ?? "");
    log("Access Token ======> ${appData.read(kKeyAccessToken)}");
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      message =
          error.response?.data["message"].toString() ?? "Something went wrong";
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    customToastMessage('Error', message);
    return false;
  }
}
