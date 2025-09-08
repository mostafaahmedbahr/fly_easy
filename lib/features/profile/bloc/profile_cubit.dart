import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/register/models/user_model.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(BuildContext context) =>
      BlocProvider.of<ProfileCubit>(context);

  List<TeamModel> myChannels = [];

  Future<void> getMyChannels() async {
    emit(GetMyChannelsLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.getData(path: EndPoints.adminChannels);
        if (response.statusCode == 200) {
          response.data['data'].forEach((channel) {
            myChannels.add(TeamModel.fromJson(channel));
          });
          emit(GetMyChannelsSuccess());
        }
      } catch (error) {
        emit(GetMyChannelsError(sl<ErrorModel>().getErrorMessage(error)));
      }
    } else {
      emit(GetMyChannelsError(AppStrings.checkInternet));
    }
  }

  Future<void> logout() async {
    emit(LogoutLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.postData(path: EndPoints.logout);
        if (response.statusCode == 200) {
          removeUserData();
          await clearLibrary();
          emit(LogoutSuccess());
        }
      } catch (error) {
        emit(LogoutError(sl<ErrorModel>().getErrorMessage(error)));
      }
    } else {
      emit(LogoutError(AppStrings.checkInternet));
    }
  }

  void refreshUserData() {
    emit(RefreshUserData());
  }

  Future<void> removeUserData() async {
    await HiveUtils.deleteUserData();
    await CacheUtils.deleteToken();
  }

  Future<void>clearLibrary()async{
    await HiveUtils.deleteLibraryCache();
  }

  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;

  Future<void> pickImage({required ImageSource source}) async {
    try {
      var file = await picker.pickImage(
        source: source,
      );
      if (file != null) {
        pickedFile = file;
        emit(PickImagesSuccess());
        updateUserImage();
      }
    } catch (error) {}
  }

  Future<void> updateUserImage() async {
    emit(UpdateImageLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.postData(
            path: EndPoints.updateUserImage,
            data: FormData.fromMap({
              'image': await MultipartFile.fromFile(pickedFile!.path,
                  filename: pickedFile!.path.split('/').last,
                  contentType: MediaType("image", "jpeg")),
            }));
        if (response.statusCode == 200) {
          await updateCachedImage(response.data['data']['profile_image']);
          pickedFile = null;
          emit(UpdateImageSuccess());
        }
      } catch (error) {
        pickedFile = null;
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        emit(UpdateImageError(errorMessage));
      }
    } else {
      emit(UpdateImageError(AppStrings.checkInternet));
    }
  }

  Future<void> updateCachedImage(String newImage) async {
    UserModel user = HiveUtils.getUserData()!;
    user.image = newImage;
    await user.save();
  }

  Future<void>deleteUserAccount()async{
    if (await sl<InternetStatus>().checkConnectivity()) {
      emit(DeleteAccountLoad());
      try{
        int id=HiveUtils.getUserData()!.id;
        final response=await DioHelper.postData(path: '${EndPoints.deleteAccount}/$id');
        if(response.statusCode==200){
          await removeUserData();
          emit(DeleteAccountSuccess());
        }
      }catch(error){
        emit(DeleteAccountError(sl<ErrorModel>().getErrorMessage(error)));
      }
    }else{
      emit(DeleteAccountError(LocaleKeys.check_internet.tr()));
    }
  }
}
