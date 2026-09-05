import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/networks/rx_base.dart';
import '../../../../../helpers/toast.dart';
import 'api.dart';
 
final class UpdateProfileRx extends RxResponseInt<Map> {
  UpdateProfileRx({required super.empty, required super.dataFetcher});
 
  final api = UpdateProfileApi.instance;
 
  ValueStream<Map> get profileStream => dataFetcher.stream;
 
  Future<bool> updateProfile({
    required String name,
    String? username,
    String? biography,
    String? tagline,
    String? phone, 
  }) async {
    try {
      final data = await api.updateProfile(
        name: name,
        username: username,
        biography: biography,
        tagline: tagline,
        phone: phone, 
      );
      handleSuccessWithReturn(data);
      return true;
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
  bool handleErrorWithReturn(error) {
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