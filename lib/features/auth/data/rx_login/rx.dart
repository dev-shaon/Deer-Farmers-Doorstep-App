// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/features/auth/data/rx_login/api.dart';
import 'package:size_matter_swt/features/auth/model/login_response.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import 'package:size_matter_swt/networks/dio/dio.dart';

import '../../../../../../constants/app_constants.dart';
import '../../../../../../helpers/di.dart';
import '../../../../../../networks/rx_base.dart';

import 'package:size_matter_swt/features/subscription/data/subscription_service.dart';

final class LoginRx extends RxResponseInt<LoginResponse> {
  String? errorMessage;
  String? refreshToken;
  final api = LoginApi.instance;

  LoginRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> login({required String email, required String password}) async {
    try {
      final data = await api.login(email: email, password: password);
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(LoginResponse data) {
    errorMessage = null;

    appData.write(kKeyAccessToken, data.data?.token ?? "");
    appData.write(kKeyUserId, data.data?.user?.id?.toString() ?? "");
    appData.write(kKeyIsLoggedIn, true);

    appData.write(kkeyisSubscribe, data.data?.user?.isSubscribe ?? false);

    log("is subscribe ===============> ${appData.read(kkeyisSubscribe)}");

    DioSingleton.instance.update(data.data?.token ?? "");
    SubscriptionService.logIn(data.data?.user?.id?.toString() ?? "");

    log("Access Token ======> ${appData.read(kKeyAccessToken)}");

    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    if (error is DioException) {
      ToastUtil.showLongToast(
        error.response?.data['message'] ?? 'Something went wrong',
      );
    }
    dataFetcher.sink.addError(error);
    return false;
  }
}
