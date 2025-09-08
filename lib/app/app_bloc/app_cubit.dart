import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';

part 'app_state.dart';

class GlobalAppCubit extends Cubit<GlobalAppState> {
  GlobalAppCubit() : super(ThemeInitial());

  static GlobalAppCubit get(BuildContext context) =>
      BlocProvider.of<GlobalAppCubit>(context);

  Future<void> changeTheme(bool isDark) async {
    await CacheUtils.setMode(isDark: isDark);
    emit(ChangeMode());
  }

  void changeLanguage() {
    emit(ChangeLanguage());
  }

  void refreshUserImage(){
    emit(RefreshUserImage());
  }
  void refreshChannelsAfterAdding() {
    emit(RefreshTeamsAfterAdd());
  }

  void refreshChannelsAfterUpdate() {
    emit(RefreshTeamsAfterUpdate());
  }
  void removeTeamAfterLeave(int teamId) {
    emit(RemoveTeamAfterLeave(teamId));
  }

  void receiveTeamNotification(dynamic teamId) {
    emit(ReceiveTeamNotification(teamId));
  }

  void receiveUserNotification(dynamic userId) {
    emit(ReceiveUserNotification(userId));
  }

  void clearTeamChatNotifications(dynamic teamId) {
    emit(ClearTeamChatNotifications(teamId));
    DioHelper.postData(path: '${EndPoints.clearTeamNotification}/$teamId');
  }

  void clearUserChatNotifications(dynamic userId, dynamic chatId) {
    emit(ClearUserChatNotifications(userId));
    DioHelper.postData(path: '${EndPoints.clearUserNotification}/$chatId');
  }
}
