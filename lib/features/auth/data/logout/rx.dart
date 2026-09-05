// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/features/auth/data/logout/api.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/networks/stream_cleaner.dart';

import '../../../../../helpers/toast.dart';
import '../../../../../networks/rx_base.dart';

import 'package:size_matter_swt/features/subscription/data/subscription_service.dart';

final class LogoutRX extends RxResponseInt<Map> {
  final api = LogoutApi.instance;

  LogoutRX({required super.empty, required super.dataFetcher});

  ValueStream get getFileData => dataFetcher.stream;

  Future<bool> logOut() async {
    try {
      final data = await api.logout();
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  void handleSuccessWithReturn(data) {
    appData.write(kKeyIsLoggedIn, false);
    SubscriptionService.logOut();
    totalDataClean();
    dataFetcher.sink.add(data);
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      ToastUtil.showErrorMessage(
        error.response?.data["message"] ?? 'Something went wrong',
      );
    }
    log(error.toString());
    dataFetcher.sink.addError(error);
    return false;
  }
}
