import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/networks/rx_base.dart';
import '../../../../../helpers/toast.dart';
import 'api.dart';
 
final class EditProfileRx extends RxResponseInt<Map> {
  EditProfileRx({required super.empty, required super.dataFetcher});
 
  final api = ProfileImageApi.instance;
 
  ValueStream<Map> get profileStream => dataFetcher.stream;
 
  Future<bool> updateAvatar({required File image}) async {
    try {
      final data = await api.updateAvatar(image: image);
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