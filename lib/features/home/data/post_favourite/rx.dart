import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../networks/rx_base.dart';
import '../../../../helpers/toast.dart';
import '../../../../networks/api_access.dart';
import '../../../favorites/model/favourite_model.dart';
import 'api.dart';

/// Favorites toggle API: [isFavorite] drives icon highlight; [message] for toast.
class PostFavouriteResult {
  final bool isFavorite;
  final String message;

  const PostFavouriteResult({required this.isFavorite, required this.message});
}

bool _parseFavoriteFlag(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is bool) return data;
  if (data is int) return data != 0;
  if (data is String) {
    final l = data.toLowerCase().trim();
    if (l == 'true' || l == '1') return true;
    if (l == 'false' || l == '0') return false;
  }
  if (data is Map) {
    final m = Map<String, dynamic>.from(data);
    for (final key in ['is_favorite', 'favorite', 'favorited', 'isFavorite']) {
      final v = m[key];
      if (v is bool) return v;
      if (v is int) return v != 0;
    }
  }
  for (final key in ['is_favorite', 'favorite', 'favorited', 'isFavorite']) {
    final v = json[key];
    if (v is bool) return v;
    if (v is int) return v != 0;
  }

  // Fallback: Check message keywords if data is ambiguous
  if (json['success'] == true) {
    final msg =
        (json['message'] ??
                (json['data'] is Map ? json['data']['message'] : ''))
            .toString()
            .toLowerCase();

    // Priority 1: Check for explicit removal words
    if (msg.contains('remover') ||
        msg.contains('removed') ||
        msg.contains('deleted') ||
        msg.contains('remove')) {
      return false;
    }

    // Priority 2: Check for explicit addition words
    if (msg.contains('added') ||
        msg.contains('favorited') ||
        msg.contains('favorite')) {
      return true;
    }

    // Priority 3: Generic success on a toggle API
    if (!json.containsKey('data')) return true;
  }

  return false;
}

String _parseMessage(Map<String, dynamic> json) {
  final m = json['message'];
  if (m != null && m.toString().trim().isNotEmpty) return m.toString();
  final data = json['data'];
  if (data is Map) {
    final inner = Map<String, dynamic>.from(data)['message'];
    if (inner != null && inner.toString().trim().isNotEmpty) {
      return inner.toString();
    }
  }
  return '';
}

final class PostFavouritesRx extends RxResponseInt {
  final api = PostFavouritesApi.instance;

  PostFavouritesRx({required super.empty, required super.dataFetcher});

  ValueStream get fillData => dataFetcher.stream;

  Future<PostFavouriteResult?> postFavourites({
    String? type,
    String? id,
  }) async {
    try {
      final Map<String, dynamic> body = {'type': type, 'id': id};
      final res = await api.postFavourites(body);
      final map = Map<String, dynamic>.from(res);
      dataFetcher.sink.add(map);

      final result = PostFavouriteResult(
        isFavorite: _parseFavoriteFlag(map),
        message: _parseMessage(map),
      );

      // New Sync
      if (id != null) {
        final itemId = int.tryParse(id);
        if (itemId != null) {
          if (type?.toLowerCase() == 'farm') {
            getFarmsRxObj.updateItemStatus(
              itemId,
              isFavorite: result.isFavorite,
            );
          } else if (type?.toLowerCase() == 'ranch') {
            getRanchesRxObj.updateItemStatus(
              itemId,
              isFavorite: result.isFavorite,
            );
          } else if (type?.toLowerCase() == 'event') {
            getEventsRxObj.updateItemStatus(
              itemId,
              isFavorite: result.isFavorite,
            );
          }
        }
      }

      return result;
    } catch (error) {
      handleErrorWithReturn(error);
      return null;
    }
  }

  Future<bool> deleteFavourites(String id) async {
    try {
      final res = await api.deleteFavourites(id);
      if (res['success'] == true ||
          (res['message']?.toString().toLowerCase().contains('success') ??
              false)) {
        ToastUtil.showSuccessMessage(
          res['message']?.toString() ?? 'Removed from favorites',
        );

        // New Sync: update the main database lists (Farms / Ranches / Events)
        try {
          final currentFavs = getFavouriteRxObj.dataFetcher.valueOrNull;
          if (currentFavs != null && currentFavs.data?.favorites != null) {
            final favoritesList = currentFavs.data!.favorites!;
            Favorite? entry;
            for (var f in favoritesList) {
              if (f.id.toString() == id) {
                entry = f;
                break;
              }
            }

            if (entry != null && entry.item != null) {
              final itemId = entry.item!.id;
              if (itemId != null) {
                getFarmsRxObj.updateItemStatus(itemId, isFavorite: false);
                getRanchesRxObj.updateItemStatus(itemId, isFavorite: false);
                getEventsRxObj.updateItemStatus(itemId, isFavorite: false);
              }
            }
          }
        } catch (e) {
          log('Sync Error: $e');
        }

        // ✅ Reactive Refresh: Update the main favorites list
        getFavouriteRxObj.fetchFavoritesData();
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
          error.response?.data['message'].toString() ?? 'Something went wrong';
      if (error.type == DioExceptionType.connectionError) {
        message = 'Check Your Network Connection';
      }
    }
    ToastUtil.showErrorMessage(message);
    return false;
  }
}
