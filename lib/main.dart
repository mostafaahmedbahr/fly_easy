import 'package:easy_localization/easy_localization.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:new_fly_easy_new/app/app.dart';

import 'package:new_fly_easy_new/bloc_observer.dart';

import 'package:new_fly_easy_new/core/cache/cache_helper.dart';

import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';

import 'package:new_fly_easy_new/core/cache_manager/custom_cache_manager.dart';

import 'package:new_fly_easy_new/core/hive/hive_initializer.dart';

import 'package:new_fly_easy_new/core/hive/hive_utils.dart';

import 'package:new_fly_easy_new/core/injection/di_container.dart';

import 'package:new_fly_easy_new/core/network/dio_helper.dart';

import 'package:new_fly_easy_new/core/routing/router.dart';

import 'package:new_fly_easy_new/firebase_options.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:intl/date_symbol_data_local.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import "package:zego_uikit/src/components/audio_video_container/layout.dart";

import 'package:app_settings/app_settings.dart';

import 'package:android_intent_plus/android_intent.dart';

import 'package:package_info_plus/package_info_plus.dart';

Future<void> openDisplayPermission() async {
  // Check if permission is already granted
  bool? canShowOverlay;

  try {
    canShowOverlay = await Permission.systemAlertWindow.isGranted;
  } catch (e) {
    if (kDebugMode) print('Error checking overlay permission: $e');
    return;
  }

  // If permission is granted, check if we already handled it before
  if (canShowOverlay) {
    bool permissionHandled = CacheUtils.isDisplayPermissionHandled() ?? false;

    if (permissionHandled) {
      if (kDebugMode)
        print('Display over apps permission already granted and handled');
      return;
    } else {
      // First time permission is granted, mark as handled
      await CacheUtils.setDisplayPermissionHandled();
      if (kDebugMode)
        print('Display over apps permission granted, marking as handled');
      return;
    }
  }

  // If permission is not granted, show permission dialog and wait
  final packageInfo = await PackageInfo.fromPlatform();

  final intent = AndroidIntent(
    action: 'android.settings.action.MANAGE_OVERLAY_PERMISSION',
    data: 'package:${packageInfo.packageName}',
  );

  await intent.launch();

  // Wait for user to make decision
  await _waitForPermissionDecision();
}

Future<void> _waitForPermissionDecision() async {
  // Wait for user to return from settings
  await Future.delayed(const Duration(seconds: 1));

  // Keep checking until permission is granted or user returns without granting
  int attempts = 0;
  const maxAttempts = 30; // Check for up to 30 times (60 seconds)

  while (attempts < maxAttempts) {
    try {
      bool canShowOverlay = await Permission.systemAlertWindow.isGranted;

      if (canShowOverlay) {
        // Permission granted, mark as handled
        await CacheUtils.setDisplayPermissionHandled();
        if (kDebugMode) print('Display over apps permission granted!');
        break;
      }

      // Wait before next check
      await Future.delayed(const Duration(seconds: 2));
      attempts++;
    } catch (e) {
      if (kDebugMode) print('Error checking permission: $e');
      break;
    }
  }

  if (attempts >= maxAttempts) {
    if (kDebugMode) print('User did not grant permission after waiting');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator().init();
  sl<CustomCacheManager>().initCacheManager();

  await EasyLocalization.ensureInitialized();

  await CacheHelper.init();

  await Hive.initFlutter();

  await HiveInitializer.initializeHive();


  DioHelper.init();
  await openDisplayPermission();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,

    overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
  );

  MobileAds.instance.initialize();

  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // AppSettings.openAppSettings(type: AppSettingsType.settings, asAnotherTask: true);

  // // AppSettings.openAppSettings(

  //

  // );

  // Get token with error handling

  String? token = await FirebaseMessaging.instance.getToken();

  if (token == null) {
    if (kDebugMode)
      print('Failed to get FCM token - check Google Play Services');
  }

  initializeDateFormatting();





  Future.delayed(
    const Duration(milliseconds: 1500),

    () => FlutterNativeSplash.remove(),
  );

  // ZegoUIKit().initLog().then((value) {

  //   ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(

  //     [ZegoUIKitSignalingPlugin()],

  //   );

  // });

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(
    sl<AppRouter>().navigatorKey,
  );

  if (CacheUtils.isLoggedIn()) {
    ZegoUIKitPrebuiltCallInvitationService().init(
      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoCallAndroidNotificationConfig(
          callIDVisibility: true,

          showOnFullScreen: true,

          showOnLockedScreen: true,

          channelID: "zego_call_channel",

          channelName: "Zego Calls",
        ),

        iOSNotificationConfig: ZegoCallIOSNotificationConfig(
          isSandboxEnvironment: true,
        ),
      ),

      // androidNotificationConfig: ZegoAndroidNotificationConfig(

      //   sound: "zego_incoming",

      // ),
      appID: 1812799240 /*input your AppID*/,

      appSign:
          'f053c726dd8a0d08b2e7183517d8b26d3e7626193c0a72906f722ddd2339c82a' /*input your AppSign*/,

      userID: HiveUtils.getUserData()!.id.toString(),

      userName: HiveUtils.getUserData()!.name,

      config: ZegoCallInvitationConfig(
        endCallWhenInitiatorLeave: true,

        missedCall: ZegoCallInvitationMissedCallConfig(
          enabled: true,

          enableDialBack: true,
        ),
      ),

      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onIncomingCallTimeout: (String callID, ZegoCallUser caller) {},

        onIncomingMissedCallClicked:
            (
              String callID,

              ZegoCallUser caller,

              ZegoCallInvitationType callType,

              List<ZegoCallUser> callees,

              String customData,

              /// The default action is to dial back the missed call
              Future<void> Function() defaultAction,
            ) async {
              /// Add your custom logic here.

              await defaultAction.call();
            },

        onIncomingMissedCallDialBackFailed: () {
          /// Add your custom logic here.
        },
      ),

      // controller: zegoUIKitPrebuiltCallController,
      plugins: [ZegoUIKitSignalingPlugin()],

      // notifyWhenAppRunningInBackgroundOrQuit: true,
      ringtoneConfig: ZegoCallRingtoneConfig(
        incomingCallPath: "assets/sounds/ringTone.mp3",
      ),

      requireConfig: (ZegoCallInvitationData data) {
        var config = (data.invitees.length > 1)
            ? ZegoCallInvitationType.videoCall == data.type
                  ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                  : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallInvitationType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        // Modify your custom configurations here.

        config.layout = ZegoLayout.gallery(
          addBorderRadiusAndSpacingBetweenView: false,
        );

        return config;
      },
    );
  }

  Bloc.observer = MyBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),

        Locale('ar'),

        Locale('fr'),

        Locale('de'),

        Locale('es'),
      ],

      path: 'assets/translations',

      fallbackLocale: const Locale('en'),

      startLocale: const Locale('en'),

      child: const MyApp(),
    ),
  );
}
