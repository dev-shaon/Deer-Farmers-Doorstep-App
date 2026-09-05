import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/common/custom_toast.dart';
import 'package:size_matter_swt/features/Tarms%20&%20Policy/model/privacy_policy_model.dart';
import 'package:size_matter_swt/networks/stream_cleaner.dart';
import '../../../../../../constants/app_constants.dart';
import '../../../../../../helpers/all_routes.dart';
import '../../../../../../helpers/di.dart';
import '../../../../../../helpers/navigation_service.dart';
import '../../../../../../networks/rx_base.dart';
import 'api.dart';

final class PolicyRx extends RxResponseInt {
  final api = PolicyApi.instance;

  PolicyRx({required super.empty, required super.dataFetcher});

  ValueStream get getPolicyStream => dataFetcher.stream;

  Future<bool> privacyPolicyData() async {
    try {
      Map resdata = await api.getfunctionNameData();
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    final model = PrivacyPolicyModel.fromJson(
      Map<String, dynamic>.from(data as Map),
    );
    dataFetcher.sink.add(model);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        totalDataClean();
        appData.write(kKeyIsLoggedIn, false);
        NavigationService.navigateToReplacementUntil(Routes.signinScreen);
      } else {
        message =
            error.response?.data["message"].toString() ??
            "Something went wrong";
      }
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    customToastMessage('Error', message);
    return false;
  }
}
