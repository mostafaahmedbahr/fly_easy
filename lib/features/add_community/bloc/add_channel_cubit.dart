import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/add_community/models/channel_details.dart';
import 'package:new_fly_easy_new/features/add_community/models/craete_channel_model.dart';
import 'package:new_fly_easy_new/features/add_community/models/update_channel_model.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/register/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

part 'add_channel_state.dart';

class AddChannelCubit extends Cubit<AddChannelState> {
  AddChannelCubit() : super(AddCommunityInitial());

  static AddChannelCubit get(BuildContext context) =>
      BlocProvider.of<AddChannelCubit>(context);

  ChannelDetails? channelDetails;

  Future<void> getChannelDetails(int id) async {
    emit(GetChannelDetailsLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response =
            await DioHelper.getData(path: '${EndPoints.channelDetails}/$id');
        if (response.statusCode == 200) {
          channelDetails = ChannelDetails.fromJson(response.data['data']);
          _initializeDataForUpdate();
          emit(GetChannelDetailsSuccess());
        }
      } catch (error) {
        emit(GetChannelDetailsError(sl<ErrorModel>().getErrorMessage(error)));
      }
    } else {
      emit(GetChannelDetailsError(AppStrings.checkInternet));
    }
  }

  void _initializeDataForUpdate() {
    channelName = channelDetails!.name;
    moderators = channelDetails!.moderators;
    guests = channelDetails!.guests;
  }

  final ImagePicker picker = ImagePicker();
  XFile? pickedImage;

  Future<void> pickImage() async {
    try {
      pickedImage =
          await picker.pickImage(imageQuality: 50, source: ImageSource.gallery);
      if (pickedImage != null) {
        emit(PickImageSuccess());
      }
    } catch (error) {}
  }

  void removeImage() {
    pickedImage = null;
    emit(PickImageSuccess());
  }

  String? channelName;
  int? level;
  List<MemberModel> moderators = [];
  List<MemberModel> guests = [];

  void addModerators(List<MemberModel> addedModerators) {
    moderators = addedModerators;
    emit(AddModerators());
  }

  void addGuests(List<MemberModel> addedGuests) {
    guests = addedGuests;
    emit(AddGuests());
  }

  Future<void> createChannel({int? parentId}) async {
    if (kDebugMode) {
      print(parentId);
    }
    emit(CreateChannelLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        CreateChannelModel newChannel = CreateChannelModel(
            name: channelName!,
            level: level!,
            image: pickedImage,
            parentId: parentId,
            guests: guests,
            moderators: moderators);
        final data=await newChannel.toJson();
        final response = await DioHelper.postData(path: EndPoints.createChannel, data: data);
        if (kDebugMode) {
          print(response);
        }
        if (response.statusCode == 200) {
          UserModel updatedUserCharge = UserModel.fromJson(response.data['data']);
          await HiveUtils.setUserData(updatedUserCharge);
          emit(CreateChannelSuccess());
        }
      } catch (error) {
        emit(CreateChannelError(sl<ErrorModel>().getErrorMessage(error,
            keys: ['name', 'moderators', 'guests', 'logo','level'])));
      }
    } else {
      emit(CreateChannelError(AppStrings.checkInternet));
    }
  }

  Future<void> updateChannel({int? parentId}) async {
    emit(CreateChannelLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        UpdateChannelModel updateChannelModel = UpdateChannelModel(
            guests: guests,
            name: channelName!,
            image: pickedImage,
            moderators: moderators,
            currentChannel: channelDetails!);
        final response = await DioHelper.postData(
            path: '${EndPoints.updateChannel}/${channelDetails!.id}',
            data: await updateChannelModel.toJson());
        if (response.statusCode == 200) {
          UserModel updatedUserCharge =
              UserModel.fromJson(response.data['data']);
          await HiveUtils.setUserData(updatedUserCharge);
          emit(CreateChannelSuccess());
        }
      } catch (error) {
        emit(CreateChannelError(sl<ErrorModel>().getErrorMessage(error,
            keys: ['name', 'moderators', 'guests', 'logo'])));
      }
    } else {
      emit(CreateChannelError(AppStrings.checkInternet));
    }
  }
}
