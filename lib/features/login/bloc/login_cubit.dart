import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
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

part 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(BuildContext context) =>
      BlocProvider.of<LoginCubit>(context);

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        var deviceToken = await _getDeviceToken();
        print("deviceToken");
        print("cEfiLIN28UQGqFDfltC96i:APA91bH4nQXzV1uC5dU7AZdhO5QRZGXDpJ-35k4jIlCyYPNHwl8Qp-zk01PpDTCmSen1bg_GVETeJ8FuaH9PhPmlvCX0x70XJpmxZ7Cvc0miyRWQN0v4jzPeO6MSQyHoWMWrMrKs4P54");
        print(deviceToken);
        final response = await DioHelper.postData(path: EndPoints.login, data: {
          'email': email,
          'password': password,
          'device_token': deviceToken,
        });
        if (response.statusCode == 200) {
          await cachingUser(response.data['data']);
          emit(LoginSuccess(
              userId: HiveUtils.getUserData()!.id.toString(),
              userName: HiveUtils.getUserData()!.name.toString()));
        }
      } catch (error) {
        if (error is DioException &&
            error.response != null &&
            error.response!.statusCode == 201) {
          emit(EmailNotVerified());
        } else {
          emit(LoginError(LocaleKeys.email_or_password_are_wrong.tr()));
        }
      }
    } else {
      emit(LoginError(AppStrings.checkInternet));
    }
  }

  Future<String> _getDeviceToken() async {
    try{
      final token = await FirebaseMessaging.instance.getToken();
      return token??"";
    }catch(error){
      _updateLocationToFirebase(error.toString());
      return "";
    }
  }


  Future<void> _updateLocationToFirebase(String error) async {
    try {
      await _databaseReference.child('errors').set({
        'error': error,
      });
    } catch (e) {
      log(e.toString());
    }
  }
  Future<void> cachingUser(Map<String, dynamic> newUser) async {
    final user = UserModel.fromJson(newUser);
    await CacheUtils.setToken(user.token);
    await HiveUtils.setUserData(user);
  }
}
