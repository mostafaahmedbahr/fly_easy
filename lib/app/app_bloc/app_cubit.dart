import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:permission_handler/permission_handler.dart';

part 'app_state.dart';

class GlobalAppCubit extends Cubit<GlobalAppState> {
  GlobalAppCubit() : super(ThemeInitial());

  static GlobalAppCubit get(BuildContext context) =>
      BlocProvider.of<GlobalAppCubit>(context);

  List<Contact> allContacts = []; // Store contacts here

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

  Future<void> requestContactsPermission() async {
    emit(PermissionLoading());

    final status = await Permission.contacts.status;

    if (status.isGranted) {
      await _loadContacts(); // جلب جهات الاتصال بعد الحصول على الإذن
      emit(PermissionGranted());
    } else if (status.isDenied) {
      final result = await Permission.contacts.request();
      if (result.isGranted) {
        await _loadContacts(); // جلب جهات الاتصال بعد الحصول على الإذن
        emit(PermissionGranted());
      } else {
        emit(PermissionDenied());
      }
    } else {
      emit(PermissionPermanentlyDenied());
    }
  }

  // دالة خاصة لجلب جهات الاتصال
  Future<void> _loadContacts() async {
    try {
      final contacts = await ContactsService.getContacts();
      allContacts = contacts.toList();
      print('تم جلب ${allContacts.length} جهة اتصال');
    } catch (e) {
      print('خطأ في جلب جهات الاتصال: $e');
      allContacts = [];
    }
  }

  // دالة لإعادة تحميل جهات الاتصال يدوياً إذا لزم الأمر
  Future<void> reloadContacts() async {
    await _loadContacts();
    emit(ContactsLoaded()); // يمكنك إضافة state جديد لهذا
  }
}