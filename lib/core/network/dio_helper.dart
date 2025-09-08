import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:new_fly_easy_new/core/network/dio_interceptor.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';


class DioHelper {
  static final _dio = Dio();

  static void init() {
    _dio.options = BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 100000),
      receiveTimeout: const Duration(seconds: 100000),
      receiveDataWhenStatusError: true,
    );
    _dio.interceptors.clear();

    _dio.interceptors.addAll([
      DioInterceptor(),
      if(kDebugMode)
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
        error: true,
      ),
    ]);
  }

  static Future<Response> postData({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  static Future<Response> getData({
    required String path,
    String? token,
    Map<String, dynamic>? query,
  }) async {
    return await _dio.get(
      path,
      queryParameters: query,
    );
  }

  static Future<Response> deleteData({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.delete(
      path,
      queryParameters: queryParameters,
    );
  }
}
