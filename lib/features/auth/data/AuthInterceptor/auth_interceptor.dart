import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:size_matter_swt/constants/app_constants.dart';
import 'package:size_matter_swt/helpers/all_routes.dart';
import 'package:size_matter_swt/helpers/navigation_service.dart';
import 'package:size_matter_swt/helpers/di.dart';
import 'package:size_matter_swt/networks/dio/dio.dart';
import 'package:size_matter_swt/networks/endpoints.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // noAuth: true হলে Authorization header add করবে না
    if (options.extra['noAuth'] == true) {
      options.headers.remove('Authorization');
      return handler.next(options);
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // noAuth: true হলে interceptor bypass — logout করবে না
    if (err.requestOptions.extra['noAuth'] == true) {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      log("Token expired — trying to refresh...");

      try {
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: url,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${appData.read(kKeyAccessToken) ?? ""}',
            },
          ),
        );

        final response = await refreshDio.post(EndPoints.refreshToken());

        if (response.statusCode == 200) {
          final newToken = response.data['data']['token'];

          appData.write(kKeyAccessToken, newToken);
          DioSingleton.instance.update(newToken);

          log("Token refreshed successfully: $newToken");

          final retryRequest = err.requestOptions;
          retryRequest.headers['Authorization'] = 'Bearer $newToken';

          final retryResponse = await DioSingleton.instance.dio.fetch(
            retryRequest,
          );
          return handler.resolve(retryResponse);
        } else {
          _handleLogout();
        }
      } catch (e) {
        log("Token refresh failed: $e");
        _handleLogout();
      }
    }

    handler.next(err);
  }

  void _handleLogout() {
    appData.write(kKeyIsLoggedIn, false);
    appData.remove(kKeyAccessToken);
    NavigationService.navigateToReplacementUntil(Routes.signinScreen);
  }
}
