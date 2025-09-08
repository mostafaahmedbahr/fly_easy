import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/register/models/user_model.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  static OtpCubit get(BuildContext context) =>
      BlocProvider.of<OtpCubit>(context);

  bool isActiveButton = false;

  void changeActiveButton(bool isActive) {
    isActiveButton = isActive;
    emit(ChangeActiveButton());
  }

  Future<String?> _getDeviceToken() async {
    return Platform.isAndroid? await FirebaseMessaging.instance.getToken():await FirebaseMessaging.instance.getAPNSToken();
  }

  Future<void> submitOtp(String otp) async {
    emit(SubmitOtpLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        var deviceToken = await _getDeviceToken();
        final response = await DioHelper.postData(path: EndPoints.verifyOtp, data: {'code': otp,'device_token':deviceToken},);
        if (response.statusCode == 200) {
          await cachingUser(response.data['data']);
          emit(SubmitOtpSuccess());
        }
      } catch (error) {
        if(error is DioException){
        }
        emit(SubmitOtpError(LocaleKeys.the_code_invalid.tr()));
      }
    } else {
      emit(SubmitOtpError(AppStrings.checkInternet));
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      await DioHelper.postData(
          path: EndPoints.resendOtp, data: {'email': email});
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  Future<void> cachingUser(Map<String, dynamic> newUser) async {
    final user = UserModel.fromJson(newUser);
    await CacheUtils.setToken(user.token);
    await HiveUtils.setUserData(user);
  }
}
