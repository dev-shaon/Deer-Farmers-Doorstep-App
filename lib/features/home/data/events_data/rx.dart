import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:size_matter_swt/helpers/toast.dart';
import '../../../../../networks/rx_base.dart';
import '../../../../constants/app_constants.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../helpers/di.dart';
import '../../../../helpers/navigation_service.dart';
import '../../../../networks/stream_cleaner.dart';
import '../../../event_list/model/events_model.dart';
import 'api.dart';

final class GetEventsRx extends RxResponseInt {
  final api = GetEventsApi.instance;

  String message = "Something went wrong";

  GetEventsRx({required super.empty, required super.dataFetcher});

  ValueStream get fillData => dataFetcher.stream;

  Future<bool> fetchEvents() async {
    try {
      int currentPage = 1;
      int lastPage = 1;
      List<Event> allEvents = [];
      EventsModel? firstResponse;

      do {
        Map<String, dynamic> resdata = Map<String, dynamic>.from(
          await api.getEventsData(page: currentPage),
        );
        EventsModel res = EventsModel.fromJson(resdata);

        if (currentPage == 1) {
          firstResponse = res;
          lastPage = res.data?.pagination?.lastPage ?? 1;
        }

        if (res.data?.events != null) {
          allEvents.addAll(res.data!.events!);
        }

        currentPage++;
      } while (currentPage <= lastPage);

      if (firstResponse != null) {
        final finalData = firstResponse.data?.copyWith(events: allEvents);
        final finalModel = firstResponse.copyWith(data: finalData);
        dataFetcher.sink.add(finalModel);
        return true;
      }
      return false;
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  void updateItemStatus(int id, {bool? isFavorite, bool? isVisited}) {
    final current = dataFetcher.valueOrNull;
    if (current is! EventsModel) return;

    final events = current.data?.events ?? [];
    bool changed = false;
    for (var event in events) {
      if (event.id == id) {
        if (isFavorite != null) event.isFavorite = isFavorite;
        if (isVisited != null) event.isVisited = isVisited;
        changed = true;
        break;
      }
    }

    if (changed) {
      dataFetcher.sink.add(current);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    // Handled inside fetchEvents loop
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
    ToastUtil.showErrorMessage(message);
    return false;
  }
}
