import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/forget_password/screens/change_pass_view.dart';
import 'package:new_fly_easy_new/features/forget_password/screens/enter_email_view.dart';
import 'package:new_fly_easy_new/features/forget_password/screens/otp_view.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  static ForgetPasswordCubit get(BuildContext context) =>
      BlocProvider.of<ForgetPasswordCubit>(context);

  int currentViewIndex = 0;
  List<Widget> views = [
    const EnterEmailView(),
    const OtpView(),
    const ChangePassView(),
  ];

  void changeCurrentView(int index) {
    currentViewIndex = index;
    emit(ChangeCurrentView());
  }

  ///  /////////////////////////
  /// //// First View ////////////
  /// ///////////////////////////

  String? email;
  Future<void> sendOtpViaEmail() async {
    emit(SendEmailLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.postData(
            path: EndPoints.forgetPassword, data: {'email': email});
        if (response.statusCode == 200) {
          emit(SendEmailSuccess());
        }
      } catch (error) {
        emit(SendOtpError(sl<ErrorModel>().getErrorMessage(error,keys: ['email'])));
      }
    } else {
      emit(SendOtpError(AppStrings.checkInternet));
    }
  }

  /// //////////////////////////////
  /// ////////  Second View  ///////
  /// ///////////////////////////////
  bool isActiveButton = false;
  String? otpCode;
  void changeActiveButton(bool isActive) {
    isActiveButton = isActive;
    emit(ChangeActiveButton());
  }
  Future<void> sendOtp() async {
    emit(SendOtpLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.postData(
            path: EndPoints.verifyOtp, data: {'code': otpCode});
        if (response.statusCode == 200) {
          emit(SendOtpSuccess());
        }
      } catch (error) {
        emit(SendOtpError(sl<ErrorModel>().getErrorMessage(error,keys: ['code'])));
      }
    } else {
      emit(SendOtpError(AppStrings.checkInternet));
    }
  }
  Future<void> resendOtp() async {
    try {
      await DioHelper.postData(
          path: EndPoints.resendOtp, data: {'email': email});
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
  }

  /// /////////////////////////////////
  /// /////// third View  ////////////
  /// ///////////////////////////////

  Future<void> sendNewPassword({
    required String newPss,
  }) async {
    emit(SendNewPassLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.postData(
            path: EndPoints.changePassword, data: {'password': newPss,'code':otpCode});
        if (response.statusCode == 200) {
          emit(SendNewPassSuccess());
        }
      } catch (error) {
        emit(SendNewPassError(sl<ErrorModel>().getErrorMessage(error)));
      }
    } else {
      emit(SendOtpError(AppStrings.checkInternet));
    }
  }
}
