import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/api_keys.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';

class DioInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiKeys.authorization] = '${ApiKeys.bearer} ${CacheUtils.getToken()}';
    options.headers[ApiKeys.accept] = ApiKeys.applicationJson;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(response.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // for some reasons the token can be invalidated before it is expired by the backend.
      // then we should navigate the user back to login page
      _performLogout();
    }
    super.onError(err, handler);
    // return handler.next(err);
  }

  void _performLogout() {
    CacheUtils.deleteToken();
    HiveUtils.deleteUserData(); // remove token from local storage
    // back to login page without using context
    // check this https://stackoverflow.com/a/53397266/9101876
    AppFunctions.showToast(message: 'You logged out, please login again', state: ToastStates.error);
    sl<AppRouter>().navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.welcome,
          (route) => false,
        );
  }
}
