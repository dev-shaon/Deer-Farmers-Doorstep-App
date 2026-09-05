// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';

import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/features/auth/data/rx_signup/api.dart';
import 'package:size_matter_swt/helpers/toast.dart';

import '../../../../../../networks/rx_base.dart';

final class SignupRx extends RxResponseInt<Map> {
  String? errorMessage;
  String? savePass;
  String? otp;
  final api = SignupApi.instance;

  SignupRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String passwordconfirmation,
  }) async {
    try {
      final data = await api.signup(
        name: name,
        email: email,
        password: password,
        passwordconfirmation: passwordconfirmation,
      );
      handleSuccessWithReturn(data);
      savePass = password;
      // otp = data['data']['otp'].toString();
      // log(" otp>>>>>>>>>>>>>>>>>>>>>>>> $otp");
      //   handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleErrorWithReturn(error) {
    if (error is DioException) {
      if (error.response != null && error.response!.data is Map) {
        final data = error.response!.data as Map;
        final msg = data['message']?.toString() ?? 'An error occurred';
        if (error.response!.statusCode == 400) {
          errorMessage = msg;
          ToastUtil.showLongToast(msg);
        } else if (data['code'] == 403) {
          errorMessage = msg;
          ToastUtil.showLongToast(msg);
        } else {
          errorMessage = msg;
          ToastUtil.showLongToast(msg);
        }
      } else {
        final msg = error.message ?? 'An error occurred';
        errorMessage = msg;
        ToastUtil.showLongToast(msg);
      }
    }
    // log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}
