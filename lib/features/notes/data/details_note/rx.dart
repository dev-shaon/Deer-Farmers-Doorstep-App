import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/common/custom_toast.dart';
import 'package:size_matter_swt/features/notes/model/note_details_model.dart';
import 'package:size_matter_swt/networks/stream_cleaner.dart';
import '../../../../../../constants/app_constants.dart';
import '../../../../../../helpers/all_routes.dart';
import '../../../../../../helpers/di.dart';
import '../../../../../../helpers/navigation_service.dart';
import '../../../../../../networks/rx_base.dart';
import 'api.dart';

final class NoteDetailsRx extends RxResponseInt<NoteDetailsModel> {
  final api = NoteDetailsApi.instance;

  NoteDetailsRx({required super.empty, required super.dataFetcher});

  ValueStream<NoteDetailsModel> get fillData => dataFetcher.stream;

  Future<bool> fetchNoteDetails(String id) async {
    try {
      Map<String, dynamic> resdata = await api.getDetailsNoteData(id) as Map<String, dynamic>;
      final NoteDetailsModel model = NoteDetailsModel.fromJson(resdata);
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
        message = error.response?.data["message"].toString() ?? "Something went wrong";
      }
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    customToastMessage('Error', message);
    return false;
  }
}