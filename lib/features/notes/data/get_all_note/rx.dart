import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/common/custom_toast.dart';
import 'package:size_matter_swt/features/notes/model/all_note_model.dart';
import 'package:size_matter_swt/networks/stream_cleaner.dart';
import '../../../../../../constants/app_constants.dart';
import '../../../../../../helpers/all_routes.dart';
import '../../../../../../helpers/di.dart';
import '../../../../../../helpers/navigation_service.dart';
import '../../../../../../networks/rx_base.dart';
import 'api.dart';

final class GetAllNotesRx extends RxResponseInt<AllNotesModel> {
  final api = GetAllNotesApi.instance;

  GetAllNotesRx({required super.empty, required super.dataFetcher});

  ValueStream<AllNotesModel> get fillData => dataFetcher.stream;

  Future<bool> getAllNotesData() async {
    try {
      Map<String, dynamic> resdata = await api.getAllNotesData() as Map<String, dynamic>;
      final AllNotesModel model = AllNotesModel.fromJson(resdata);
      dataFetcher.sink.add(model);
      return true;
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  Future<bool> handleErrorWithReturn(error) async {
    String message = 'Something went wrong';
    log(error.toString());

    if (error is DioException) {
      if (error.response?.statusCode == 401) {
        totalDataClean();
        appData.write(kKeyIsLoggedIn, false);
        NavigationService.navigateToReplacementUntil(Routes.signinScreen);
      } else {
        message = error.response?.data["message"]?.toString() ??
            'Something went wrong';
      }

      if (error.type == DioExceptionType.connectionError) {
        message = 'Check Your Network Connection';
      }
    }

    customToastMessage('Error', message);
    return false;
  }
}
