// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/features/auth/data/forget_resent_otp/api.dart';
import 'package:size_matter_swt/helpers/di.dart';


import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';

final class ResendForgotOtpRx extends RxResponseInt<Map> {
  String? errorMessage;
  String? resetToken;
  final api = ResendForgotOtpApi.instance;

  ResendForgotOtpRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> verifyOtp({required String email, required String otp}) async {
    try {
      final data = await api.resendOtp(email: email, );
      handleSuccessWithReturn(data);
      resetToken = data['token'];
      appData.write(kkeyForgetOtpToken, data['token']);
      log("Token is ============> ${appData.read(kkeyForgetOtpToken)}");
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  Future<bool> resend({required String email}) async {
    try {
      final data = await api.resendOtp(email: email);
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleErrorWithReturn(error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;

      if (statusCode == 429) {
        // ✅ 429 handle
        ToastUtil.showErrorMessage(
          responseData['errors'] ?? 'Please wait before requesting a new OTP.',
        );
      } else if (statusCode == 400) {
        ToastUtil.showErrorMessage(responseData["message"] ?? 'Bad request');
      } else if (responseData?['code'] == 403) {
        errorMessage = responseData['message'];
      } else {
        ToastUtil.showErrorMessage(
          responseData?['message'] ?? 'Something went wrong',
        );
      }
    }
    dataFetcher.sink.addError(error);
    return false;
  }
}