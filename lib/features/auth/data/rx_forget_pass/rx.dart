// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/features/auth/data/rx_forget_pass/api.dart';
import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';

final class ForgetPassRx extends RxResponseInt<Map> {
  String? errorMessage;
  String? otp;
  final api = ForgotPassApi.instance;

  ForgetPassRx({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> forgetPass({required String email}) async {
    try {
      final data = await api.forgotPassword(email: email);
      handleSuccessWithReturn(data);
      //   otp = data['data']['otp'].toString();
      // log(" otp>>>>>>>>>>>>>>>>>>>>>>>> $otp");
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleErrorWithReturn(error) {
    if (error is DioException) {
      if (error.response!.statusCode == 400) {
        /// ToastUtil.showShortToast(error.response!.data["message"]);
        ToastUtil.showLongToast(error.response!.data['message']);
      } else if (error.response!.data['code'] == 403) {
        ToastUtil.showLongToast(error.response!.data['message']);
      } else {
        ToastUtil.showLongToast(error.response!.data['message']);
      }
    }
    // log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}
