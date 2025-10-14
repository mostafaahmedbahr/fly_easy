import 'package:contacts_service_plus/contacts_service_plus.dart';
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



  // ============= أوضاع النظام واللغة ============= //
  Future<void> changeTheme(bool isDark) async {
    await CacheUtils.setMode(isDark: isDark);
    emit(ChangeMode());
  }

  void changeLanguage() => emit(ChangeLanguage());

  void refreshUserImage() => emit(RefreshUserImage());

  void refreshChannelsAfterAdding() => emit(RefreshTeamsAfterAdd());

  void refreshChannelsAfterUpdate() => emit(RefreshTeamsAfterUpdate());

  void removeTeamAfterLeave(int teamId) =>
      emit(RemoveTeamAfterLeave(teamId));

  void receiveTeamNotification(dynamic teamId) =>
      emit(ReceiveTeamNotification(teamId));

  void receiveUserNotification(dynamic userId) =>
      emit(ReceiveUserNotification(userId));

  void clearTeamChatNotifications(dynamic teamId) {
    emit(ClearTeamChatNotifications(teamId));
    DioHelper.postData(path: '${EndPoints.clearTeamNotification}/$teamId');
  }

  void clearUserChatNotifications(dynamic userId, dynamic chatId) {
    emit(ClearUserChatNotifications(userId));
    DioHelper.postData(path: '${EndPoints.clearUserNotification}/$chatId');
  }

  List<Contact> allContacts = [];
  bool _contactsLoaded = false;

  // ============= إذن جهات الاتصال ============= //
  Future<void> requestContactsPermission() async {
    // ✅ لا تعيد emit إذا الاتصالات محملة مسبقاً
    if (_contactsLoaded && allContacts.isNotEmpty) {
      print("✅ جهات الاتصال محملة مسبقاً");
      return;
    }

    emit(PermissionLoading());
    final status = await Permission.contacts.status;

    if (status.isGranted) {
      await _loadContactsOnce();
      // ✅ emit مرة واحدة فقط
      if (!_contactsLoaded) {
        emit(PermissionGranted());
      }
    } else if (status.isDenied) {
      final result = await Permission.contacts.request();
      if (result.isGranted) {
        await _loadContactsOnce();
        // ✅ emit مرة واحدة فقط
        if (!_contactsLoaded) {
          emit(PermissionGranted());
        }
      } else {
        emit(PermissionDenied());
      }
    } else {
      emit(PermissionPermanentlyDenied());
    }
  }

  // ✅ تحميل جهات الاتصال مرة واحدة فقط
  // في app_cubit.dart
  Future<void> _loadContactsOnce() async {
    if (_contactsLoaded) return;

    try {
      print("⚡ تحميل جهات الاتصال بشكل معجل...");

      // ✅ استخدم withProperties: false علشان تتحميل أسرع
      final contacts = await ContactsService.getContacts(
        withThumbnails: false, // ❌ لا تحمل الصور المصغرة
        photoHighResolution: false, // ❌ لا تحمل الصور عالية الجودة
      );

      allContacts = contacts.toList();
      _contactsLoaded = true;

      print('✅ تم جلب ${allContacts.length} جهة اتصال في وقت سريع');
    } catch (e) {
      print('⚠️ خطأ في تحميل الاتصالات: $e');
      allContacts = [];
    }
  }

  // لإعادة تحميل يدوي
  Future<void> reloadContacts() async {
    _contactsLoaded = false;
    allContacts = [];
    await _loadContactsOnce();
    // ✅ emit مرة واحدة بعد إعادة التحميل
    emit(PermissionGranted());
  }
}
