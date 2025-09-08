import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/register/models/user_model.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  static EditProfileCubit get(BuildContext context) =>
      BlocProvider.of<EditProfileCubit>(context);

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String countryCode,
    required String? workId,
    required String? company,
  }) async {
    emit(EditProfileLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.postData(
            path: EndPoints.updateUserData,
            data: {'name': name, 'phone': phone,'country_code':countryCode,'work_id':workId,'company':company});
        if (response.statusCode == 200) {
          _updateCache(name: name, phone: phone,countryCode: countryCode,workId:workId,company: company);
          emit(EditProfileSuccess());
        }
      } catch (error) {
        emit(EditProfileError(sl<ErrorModel>().getErrorMessage(error)));
      }
    } else {
      emit(EditProfileError(AppStrings.checkInternet));
    }
  }

  Future<void> _updateCache(
      {required String name, required String phone,required String countryCode,String? workId,String?company}) async {
    UserModel user = HiveUtils.getUserData()!;
    user.phone = phone;
    user.name = name;
    user.countryCode=countryCode;
    user.workId=workId;
    user.company=company;
    user.save();
  }
}
