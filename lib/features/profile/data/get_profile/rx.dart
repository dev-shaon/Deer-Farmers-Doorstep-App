import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/features/profile/model/profile_model.dart';
import 'package:size_matter_swt/networks/rx_base.dart';
import '../../../../../helpers/toast.dart';
import 'api.dart';

final class GetProfileRx extends RxResponseInt<Map> {
  GetProfileRx({required super.empty, required super.dataFetcher});

  final api = GetProfileApi.instance;

  ValueStream<Map> get profileStream => dataFetcher.stream;

  Profilemodel? profileModel;
  String? name;
  String? email;
  String? avatarUrl;
  String? phone; 
  bool? isSubscribe;
  Subscription? subscription;

  Future<bool> getProfile() async {
    try {
      final data = await api.getProfile();
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) {
    try {
      profileModel = Profilemodel.fromJson(Map<String, dynamic>.from(data));
      name = profileModel?.data?.profile?.name ?? data['data']?['profile']?['name'];
      email = profileModel?.data?.email ?? data['data']?['email'];
      avatarUrl = profileModel?.data?.profile?.avatar ?? data['data']?['profile']?['avatar'];
      phone = profileModel?.data?.phone ?? data['data']?['phone'];
      isSubscribe = profileModel?.data?.isSubscribe;
      subscription = profileModel?.data?.subscription;
    } catch (e) {
      name = data['data']?['profile']?['name'];
      email = data['data']?['email'];
      avatarUrl = data['data']?['profile']?['avatar'];
      phone = data['data']?['phone'];
    }

    log("Name =====> $name");
    log("Email =====> $email");
    log("Avatar =====> $avatarUrl");
    log("Phone =====> $phone"); 

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