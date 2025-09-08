import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/ad_mob/ad_mob_service.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/notifications/fcm.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/show_case_widget.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_image_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/forward_messages/models/forward_info_model.dart';
import 'package:new_fly_easy_new/features/home/bloc/home_cubit.dart';
import 'package:new_fly_easy_new/features/home/screens/home_screen.dart';
import 'package:new_fly_easy_new/features/library/bloc/library_bloc/library_cubit.dart';
import 'package:new_fly_easy_new/features/library/screens/library_screen.dart';
import 'package:new_fly_easy_new/features/profile/bloc/profile_cubit.dart';
import 'package:new_fly_easy_new/features/profile/screens/settings_screen.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';
import 'package:new_fly_easy_new/features/teams/screens/teams_screen.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:uuid/uuid.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> with Fcm {
  ThemeData get themeData => Theme.of(context);
  late PersistentTabController _controller;
  final bottomNavHeight = 55.0.h;
  late StreamSubscription _backgroundShare;
  final _sharedFiles = <SharedMediaFile>[];
  final GlobalKey _homeHintKey = GlobalKey();
  final GlobalKey _teamsHintKey = GlobalKey();
  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _initializeFcm();
    _initializeReceivingSharedData();
    _askStoragePermission();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _backgroundShare.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PersistentTabView(
            padding: const NavBarPadding.only(
              left: 0,
              right: 0,
            ),
            context,
            controller: _controller,
            navBarHeight: bottomNavHeight,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: themeData.cardColor,
            handleAndroidBackButtonPress: true,
            resizeToAvoidBottomInset: true,
            stateManagement: true,
            hideNavigationBarWhenKeyboardShows: true,
            decoration: NavBarDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                colorBehindNavBar: themeData.cardColor,
                boxShadow: [
                  const BoxShadow(color: Colors.black),
                ]),
            popAllScreensOnTapOfSelectedTab: true,
            popAllScreensOnTapAnyTabs: true,
            onItemSelected: (value) {
              // layoutCubit.changeAppBarTitle(value);
            },
            margin: EdgeInsets.zero,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties(
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            navBarStyle: NavBarStyle.simple, // Choose the nav bar style with this property.
          ),
        ),
        (_bannerAdLoaded)
            ? SizedBox(
            width: AdSize.fullBanner.width.toDouble(),
            height: AdSize.fullBanner.height.toDouble(),
            child: AdWidget(ad: _bannerAd!))
            : SizedBox(
          height: 15.h,
        ),
      ],
    );
  }

  /// //////////////////////////////////////////////////
  /// ////////////// Helper Methods //////////////////////
  /// /////////////////////////////////////////////////////
  void _createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId!,
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, error) {
            if (kDebugMode) {
              print(error.message);
              print(error.responseInfo);
              print(
                  'Failed//////////////////////////////////////////////////////');
            }
            ad.dispose();
          },
          onAdClosed: (ad) {
            if (kDebugMode) {
              print(
                  'Closed//////////////////////////////////////////////////////////');
            }
            ad.dispose();
          },
          onAdLoaded: (ad) {
            if (kDebugMode) {
              print('Loaded');
            }
            setState(() {
              _bannerAdLoaded = true;
            });
          },
        ),
        request: const AdRequest())
      ..load();
  }

  void _initializeFcm() async {
    initNotifications(context);
  }

  void _initializeReceivingSharedData() {
    // Listen to media sharing coming from outside the app while the app is in the memory.
    try {
      _backgroundShare = ReceiveSharingIntent.instance.getMediaStream().listen(
            (value) {
          _sharedFiles.clear();
          _sharedFiles.addAll(value);
          if (_sharedFiles.isNotEmpty) {
            sl<AppRouter>().navigatorKey.currentState!.pushNamed(
                Routes.shareExternal,
                arguments: ForwardInfoModel(messages: _getSharedMessages()));
          }
        },
      );
      // Get the media sharing coming from outside the app while the app is closed.
      ReceiveSharingIntent.instance.getInitialMedia().then((value) {
        _sharedFiles.clear();
        _sharedFiles.addAll(value);
        if (_sharedFiles.isNotEmpty) {
          sl<AppRouter>().navigatorKey.currentState!.pushNamed(
              Routes.shareExternal,
              arguments: ForwardInfoModel(messages: _getSharedMessages()));
        } // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.instance.reset();
      });
    } catch (error) {
      AppFunctions.showToast(
          message: AppStrings.errorMessage, state: ToastStates.error);
    }
  }

  MessageType _getMessageType(String type, {String? path}) {
    if (type.startsWith('text')) {
      if (path!.startsWith('https')) {
        return MessageType.link;
      } else {
        return MessageType.text;
      }
    } else if (type.startsWith('image')) {
      return MessageType.image;
    } else if (type.startsWith('video')) {
      return MessageType.video;
    } else {
      return MessageType.file;
    }
  }

  List<MessageModel> _getSharedMessages() {
    List<MessageModel> messages = [];
    for (var element in _sharedFiles) {
      MessageType messageType =
      _getMessageType(element.type.name, path: element.path);
      if (messageType == MessageType.text) {
        messages.add(MessageModel(
          text: element.path,
          senderId: HiveUtils.getUserData()!.id,
          senderImage: HiveUtils.getUserData()!.image,
          senderName: HiveUtils.getUserData()!.name,
          virtualId: sl<Uuid>().v1(),
          type: MessageType.text.name,
          dateTime: Timestamp.now(),
        ));
      } else if (messageType == MessageType.link) {
        messages.add(MessageModel(
          text: element.path,
          senderId: HiveUtils.getUserData()!.id,
          senderImage: HiveUtils.getUserData()!.image,
          senderName: HiveUtils.getUserData()!.name,
          virtualId: sl<Uuid>().v1(),
          type: MessageType.link.name,
          dateTime: Timestamp.now(),
        ));
      } else if (messageType == MessageType.image) {
        messages.add(MessageModel(
          images: [
            ChatImageModel(virtualId: sl<Uuid>().v1(), file: File(element.path))
          ],
          senderId: HiveUtils.getUserData()!.id,
          senderImage: HiveUtils.getUserData()!.image,
          senderName: HiveUtils.getUserData()!.name,
          virtualId: sl<Uuid>().v1(),
          type: MessageType.image.name,
          dateTime: Timestamp.now(),
        ));
      } else if (messageType == MessageType.video) {
        messages.add(MessageModel(
          video: VideoModel(
              videoVirtualId: sl<Uuid>().v1(), videoFile: File(element.path)),
          senderId: HiveUtils.getUserData()!.id,
          senderImage: HiveUtils.getUserData()!.image,
          senderName: HiveUtils.getUserData()!.name,
          virtualId: sl<Uuid>().v1(),
          type: MessageType.video.name,
          dateTime: Timestamp.now(),
        ));
      }
    }
    return messages;
  }

  Future<bool> _askStoragePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
      ].request(); //import 'package:permission_handler/permission_handler.dart';

      havePermission = request.values.every((status) => status == PermissionStatus.granted);
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }
    if (!havePermission) {
      // if no permission then open app-setting
      await openAppSettings();
    }

    return havePermission;
  }


  /// //////////////////////////////////////////////////
  /// ////////////// Helper widgets //////////////////////
  /// /////////////////////////////////////////////////////
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        title: LocaleKeys.home.tr(),
        textStyle: TextStyle(fontSize: 11.sp,),
        icon: CustomShowCase(
          caseKey: _homeHintKey,
          description: AppStrings.homeHint,
          child: const Icon(
            AppIcons.message,
            size: 24,
          ),
        ),
        activeColorPrimary: themeData.indicatorColor,
        activeColorSecondary: themeData.indicatorColor,
        inactiveColorPrimary: themeData.disabledColor,
        inactiveColorSecondary: themeData.disabledColor,
        inactiveIcon: const Icon(
          AppIcons.message,
          size: 24,
        ),
      ),
      PersistentBottomNavBarItem(
        title: LocaleKeys.teams.tr(),
        textStyle: TextStyle(fontSize: 11.sp),
        icon: CustomShowCase(
            caseKey: _teamsHintKey,
            description: AppStrings.teamsHint,
            child: const Icon(Icons.groups, size: 32)),
        activeColorPrimary: themeData.indicatorColor,
        activeColorSecondary: themeData.indicatorColor,
        inactiveColorPrimary: themeData.disabledColor,
        inactiveColorSecondary: themeData.disabledColor,
        inactiveIcon: const Icon(Icons.groups, size: 32),
      ),
      PersistentBottomNavBarItem(
        title: LocaleKeys.library.tr(),
        textStyle: TextStyle(fontSize: 11.sp,),
        icon: const Icon(AppIcons.folder, size: 24),
        activeColorPrimary: themeData.indicatorColor,
        activeColorSecondary: themeData.indicatorColor,
        inactiveColorPrimary: themeData.disabledColor,
        inactiveColorSecondary: themeData.disabledColor,
        inactiveIcon: const Icon(AppIcons.folder, size: 24),
      ),
      PersistentBottomNavBarItem(
        title: LocaleKeys.profile.tr(),
        textStyle: TextStyle(fontSize: 11.sp,),
        icon: const Icon(AppIcons.profile, size: 24),
        activeColorPrimary: themeData.indicatorColor,
        activeColorSecondary: themeData.indicatorColor,
        inactiveColorPrimary: themeData.disabledColor,
        inactiveColorSecondary: themeData.disabledColor,
        inactiveIcon: const Icon(AppIcons.profile, size: 24),
      ),
    ];
  }

  List<Widget> _buildScreens() =>
      [
        BlocProvider(
            create: (context) => HomeCubit(), child: const HomeScreen()),
        BlocProvider(
            create: (context) => TeamsCubit(), child: const TeamsScreen()),
        BlocProvider(
            create: (context) => LibraryCubit(), child: const LibraryScreen()),
        BlocProvider(
            create: (context) => ProfileCubit(), child: const ProfileScreen()),
      ];
}
