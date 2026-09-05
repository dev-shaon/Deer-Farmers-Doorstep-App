import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/networks/rx_base.dart';
import '../../../../helpers/toast.dart';
import 'api.dart';
 
final class ChangePasswordRx extends RxResponseInt<Map> {
  final api = ChangePasswordApi.instance;
 
  ChangePasswordRx({required super.empty, required super.dataFetcher});
 
  ValueStream get getFileData => dataFetcher.stream;
 
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final data = await api.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return handleSuccessWithReturn(data);
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }
 
  @override
  handleSuccessWithReturn(data) {
    dataFetcher.sink.add(data);
    return true;
  }
 
  @override
  handleErrorWithReturn(error) {
    log(error.toString());
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionError) {
        ToastUtil.showErrorMessage("Check Your Network Connection");
      } else {
        ToastUtil.showErrorMessage(
          error.response?.data["message"] ?? 'Something went wrong',
        );
      }
    }
    dataFetcher.sink.addError(error);
    return false;
  }
}