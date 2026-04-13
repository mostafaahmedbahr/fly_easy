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
// import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import "package:zego_uikit/src/components/audio_video_container/layout.dart";
import 'package:app_settings/app_settings.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> openDisplayPermission() async {
  final packageInfo = await PackageInfo.fromPlatform();

  final intent = AndroidIntent(
    action: 'android.settings.action.MANAGE_OVERLAY_PERMISSION',
    data: 'package:${packageInfo.packageName}',
  );

  await intent.launch();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  openDisplayPermission();
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
  ServiceLocator().init();
  DioHelper.init();
  sl<CustomCacheManager>().initCacheManager();
  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  await Hive.initFlutter();
  await HiveInitializer.initializeHive();

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
          enableDialBack : true,
        ),
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onIncomingCallTimeout: (
            String callID,
            ZegoCallUser caller
            ) {},
        onIncomingMissedCallClicked: (
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
