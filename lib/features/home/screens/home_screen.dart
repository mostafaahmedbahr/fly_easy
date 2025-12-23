import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/dialog_progress_indicator.dart';
import 'package:new_fly_easy_new/core/widgets/show_case_widget.dart';
import 'package:new_fly_easy_new/features/contacts/bloc/contacts_cubit.dart';
import 'package:new_fly_easy_new/features/home/bloc/home_cubit.dart';
import 'package:new_fly_easy_new/features/home/models/user_chat_model.dart';
import 'package:new_fly_easy_new/features/home/widgets/chats_list.dart';
import 'package:new_fly_easy_new/features/home/widgets/user_image.dart';
import 'package:new_fly_easy_new/features/widgets/custom_network_image.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../ad_mob/ad_mob_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeCubit get cubit => HomeCubit.get(context);

  final PagingController<int, UserChatModel> _chatsPagingController = PagingController<int, UserChatModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);
  GlobalKey? _searchHintKey;
  GlobalKey? _notificationsHintKey;
  int _notificationsNum = 0;
  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;
  @override
  void initState() {
    super.initState();
  //  _initializeShowHints();
    Future.microtask(() => cubit.getNotificationsCount());
    _createBannerAd();
  }
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
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: _blocListener,
      child: Scaffold(
        appBar: _appBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_bannerAdLoaded)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: SizedBox(
                    width: AdSize.fullBanner.width.toDouble(),
                    height: AdSize.fullBanner.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!)),
              )
            else
              SizedBox(height: 15.h,),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            //   child: Column(
            //     children: [
            //       RoundedNetworkImage(
            //         width: context.width,
            //         height: 100.h,
            //         radius: 15,
            //         image:
            //             'https://amhere.net/storage/01J807NWN4JXPPB6CXQQWPA6JB.jfif',
            //       ),
            //       // SizedBox(
            //       //   height: 10.h,
            //       // ),
            //       // CustomShowCase(
            //       //   description: AppStrings.searchHint,
            //       //   caseKey: _searchHintKey,
            //       //   child: SearchField(
            //       //     onChange: (value) {},
            //       //     hint: 'hint',
            //       //     isEnabled: false,
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Text(
                  LocaleKeys.recent.tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                )),
            Expanded(
                child: ChatsList(chatsPagingController: _chatsPagingController))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chatsPagingController.dispose();
    super.dispose();
  }

  /// //////////////////////////////////////////////////
  /// ////////////// Helper Widgets ////////////////////
  /// //////////////////////////////////////////////////
  AppBar _appBar() => AppBar(
        leadingWidth: context.width * .3,
        leading: Row(
          children: [
            SizedBox(
              width: 5.w,
            ),
            IconButton(
                icon: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    CustomShowCase(
                      description: AppStrings.notificationsHint,
                      caseKey: _notificationsHintKey,
                      child: const Icon(
                        // IconlyBroken.notification,
                        CupertinoIcons.bell,
                        size: 30,
                      ),
                    ),
                    BlocConsumer<GlobalAppCubit, GlobalAppState>(
                      listenWhen: (previous, current) =>
                          current is ReceiveUserNotification ||
                          current is ReceiveTeamNotification,
                      listener: (context, state) {
                        if (state is ReceiveTeamNotification ||
                            state is ReceiveUserNotification) {
                          _notificationsNum++;
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is ReceiveUserNotification ||
                          current is ReceiveTeamNotification,
                      builder: (context, state) =>
                          BlocBuilder<HomeCubit, HomeState>(
                        buildWhen: (previous, current) =>
                            current is GetNotificationsCount,
                        builder: (context, state) => Visibility(
                          visible: _notificationsNum > 0,
                          replacement: const SizedBox.shrink(),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 8,
                            child: Text(
                              _notificationsNum > 99
                                  ? '+99'
                                  : '$_notificationsNum',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                onPressed: _onNotificationsPressed,
                padding: EdgeInsets.zero,
                alignment: AlignmentDirectional.centerStart),
            IconButton(
              onPressed: _onSearchPressed,
              icon: CustomShowCase(
                description: AppStrings.searchHint,
                caseKey: _searchHintKey,
                child: const Icon(
                  // IconlyBroken.search,
                 CupertinoIcons.search,
                  size: 30,
                ),
              ),
              padding: EdgeInsets.zero,
              alignment: AlignmentDirectional.centerStart,
            ),
          ],
        ),
        actions: const [
          UserImage(),
        ],
        title: Text(
          LocaleKeys.home.tr(),
        ),
        centerTitle: true,
      );

  /// //////////////////////////////////////////////////
  /// ////////////// Helper Methods ////////////////////
  /// //////////////////////////////////////////////////

  void _onNotificationsPressed() {
    _resetNotifications();
    context.push(Routes.notifications);
  }

  void _onSearchPressed() {
    context.push(Routes.search);
  }

  void _resetNotifications() {
    cubit.resetNotificationsCounter();
    setState(() {
      _notificationsNum = 0;
    });
  }

  void _initializeShowHints() {
    if (!(CacheUtils.isSearchHintShown() &&
        CacheUtils.isNotificationsHintShown())) {
      _notificationsHintKey = GlobalKey();
      _searchHintKey = GlobalKey();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context)
            .startShowCase([_searchHintKey!, _notificationsHintKey!]);
        CacheUtils.setNotificationsHint();
        CacheUtils.setSearchHint();
      });
    }
  }

  void _blocListener(BuildContext context, HomeState state) {
    if (state is DeleteChatLoad) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const DialogIndicator(),
      );
    } else if (state is DeleteChatSuccess) {
      _chatsPagingController.itemList!
          .removeWhere((element) => element.id == state.chatId);
      Navigator.of(context, rootNavigator: true).pop();
    } else if (state is GetNotificationsCount) {
      _notificationsNum = 0;
    }
  }
}
