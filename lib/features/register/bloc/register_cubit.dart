import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(BuildContext context) =>
      BlocProvider.of<RegisterCubit>(context);

  Future<void> register({
    required String email,
    required String name,
    required String password,
    required String phone,
    required String countryCode,
    String? workId,
    String? company,
  }) async {
    emit(RegisterLoading());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response =
        await DioHelper.postData(path: EndPoints.register, data: {
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
          'country_code':countryCode,
          'work_id':workId,
          'company':company
        });
        if (response.statusCode == 200) {
          emit(RegisterSuccess());
        }
      } catch (error) {
        emit(RegisterError(sl<ErrorModel>().getErrorMessage(
            error, keys: ['email', 'name', 'phone',])));
      }
    } else {
      emit(RegisterError(AppStrings.checkInternet));
    }
  }
}
