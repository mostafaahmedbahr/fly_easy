import 'package:new_fly_easy_new/core/cache/cache_helper.dart';
import 'package:new_fly_easy_new/core/cache/cache_keys.dart';

class CacheUtils {
  static Future<void> setToken(String token) async {
    await CacheHelper.putData(key: CacheKeys.token, value: token);
  }

  static String? getToken() {
    return CacheHelper.getData(key: CacheKeys.token);
  }

  static Future<void> deleteToken() async {
    await CacheHelper.removeValue(key: CacheKeys.token);
  }

  static Future<void> setIsOpenedBefore() async {
    await CacheHelper.putData(key: CacheKeys.isOpenedBefore, value: true);
  }

  static bool isOpenedBefore() {
    return CacheHelper.getData(key: CacheKeys.isOpenedBefore) ?? false;
  }

  static bool isLoggedIn() {
    return CacheHelper.getData(key: CacheKeys.token) == null ? false : true;
  }

  static Future<void> setMode({required bool isDark}) async {
    await CacheHelper.putData(key: CacheKeys.mode, value: isDark);
  }

  static bool isDarkMode() {
    final bool? mode = CacheHelper.getData(key: CacheKeys.mode);
    return (mode != null && mode == true);
  }

  static Future<void> setAcceptConditions() async {
    await CacheHelper.putData(key: CacheKeys.acceptConditions, value: true);
  }

  static bool isAcceptConditions() {
    return CacheHelper.getData(key: CacheKeys.acceptConditions) == null
        ? false
        : true;
  }

  static Future<void> setNotificationsHint() async {
    await CacheHelper.putData(
      key: CacheKeys.isNotificationsHintShown,
      value: true,
    );
  }

  static Future<void> setSearchHint() async {
    await CacheHelper.putData(key: CacheKeys.isSearchHintShown, value: true);
  }

  static Future<void> setEmailHint() async {
    await CacheHelper.putData(key: CacheKeys.isEmailHintShown, value: true);
  }

  static Future<void> setPersonalChatHint() async {
    await CacheHelper.putData(
      key: CacheKeys.isPersonalChatHintShown,
      value: true,
    );
  }

  static Future<void> setHowToUseHint() async {
    await CacheHelper.putData(key: CacheKeys.isHowToUseHintShown, value: true);
  }

  static Future<void> setCreateTeamHint() async {
    await CacheHelper.putData(
      key: CacheKeys.isCreateTeamHintShown,
      value: true,
    );
  }

  static Future<void> setDisplayPermissionHandled() async {
    await CacheHelper.putData(
      key: CacheKeys.isDisplayPermissionHandled,
      value: true,
    );
  }

  static bool? isDisplayPermissionHandled() {
    return CacheHelper.getData(key: CacheKeys.isDisplayPermissionHandled);
  }

  static bool isNotificationsHintShown() {
    return CacheHelper.getData(key: CacheKeys.isNotificationsHintShown) == null
        ? false
        : true;
  }

  static bool isSearchHintShown() {
    return CacheHelper.getData(key: CacheKeys.isSearchHintShown) == null
        ? false
        : true;
  }

  static bool isEmailHintShown() {
    return CacheHelper.getData(key: CacheKeys.isEmailHintShown) == null
        ? false
        : true;
  }

  static bool isPersonalChatHintShown() {
    return CacheHelper.getData(key: CacheKeys.isPersonalChatHintShown) == null
        ? false
        : true;
  }

  static bool isHowToUseHintShown() {
    return CacheHelper.getData(key: CacheKeys.isHowToUseHintShown) == null
        ? false
        : true;
  }

  static bool isCreateTeamHintShown() {
    return CacheHelper.getData(key: CacheKeys.isCreateTeamHintShown) == null
        ? false
        : true;
  }
}
