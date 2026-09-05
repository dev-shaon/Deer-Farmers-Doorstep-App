import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/api_access.dart';
import '../../../visited/model/visited_model.dart';
import 'api.dart';

final class PostVisitedRx extends RxResponseInt {
  final api = PostVisitedApi.instance;

  PostVisitedRx({required super.empty, required super.dataFetcher});

  ValueStream get fillData => dataFetcher.stream;

  Future<bool> postVisited({String? type, String? id}) async {
    try {
      Map<String, dynamic> data = {"type": type, "id": id};

      Map resdata = await api.postVisited(data);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  Future<bool> deleteVisited(String id) async {
    try {
      final res = await api.deleteVisited(id);
      if (res['success'] == true ||
          (res['message']?.toString().toLowerCase().contains('success') ??
              false)) {
        ToastUtil.showSuccessMessage(
          res['message']?.toString() ?? 'Removed from visited list',
        );

        // Sync FIRST — read old data before refresh overwrites it
        try {
          final currentVisited = getVisitedRxObj.dataFetcher.valueOrNull;
          if (currentVisited is VisitedModel) {
            Visited? entry;
            for (var v in (currentVisited.data?.visited ?? [])) {
              if (v.id.toString() == id) {
                entry = v;
                break;
              }
            }
            if (entry != null && entry.item != null) {
              final itemId = entry.item!.id;
              if (itemId != null) {
                getFarmsRxObj.updateItemStatus(itemId, isVisited: false);
                getRanchesRxObj.updateItemStatus(itemId, isVisited: false);
                getEventsRxObj.updateItemStatus(itemId, isVisited: false);
              }
            }
          }
        } catch (e) {
          log('Sync Error: $e');
        }

        // THEN refresh the visited list from server
        getVisitedRxObj.fetchVisitedData();

        return true;
      }
      return false;
    } catch (error) {
      handleErrorWithReturn(error);
      return false;
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    String message = 'Something went wrong';
    log(error.toString());
    if (error is DioException) {
      message =
          error.response?.data["message"].toString() ?? "Something went wrong";
      if (error.type == DioExceptionType.connectionError) {
        message = "Check Your Network Connection";
      }
    }
    ToastUtil.showErrorMessage(message);
    return false;
  }
}
