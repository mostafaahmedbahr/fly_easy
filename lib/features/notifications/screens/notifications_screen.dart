import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/ad_mob/ad_mob_service.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/notifications/bloc/notifications_cubit.dart';
import 'package:new_fly_easy_new/features/notifications/model/notifications_model.dart';
import 'package:new_fly_easy_new/features/notifications/widgets/notification_item.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsCubit get cubit => NotificationsCubit.get(context);
  final PagingController<int, NotificationModel>
      _notificationsPagingController = PagingController<int, NotificationModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);

  void _getInitialNotifications() {
    _notificationsPagingController.addPageRequestListener((pageKey) {
      cubit.getNotifications(
        pageKey,
        _notificationsPagingController,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitialNotifications();
    _showAdvSnackBar();
    _createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _notificationsPagingController.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: RefreshIndicator.adaptive(
          color: AppColors.lightPrimaryColor,
          onRefresh: () async => _notificationsPagingController.refresh(),
          child: PagedListView.separated(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
            pagingController: _notificationsPagingController,
            separatorBuilder: (context, index) => _customDivider(),
            builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
                itemBuilder: (context, item, index) => Dismissible(
                    background: Container(
                      decoration: const BoxDecoration(color: Colors.red),
                      child: const Icon(
                        AppIcons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      cubit.deleteNotification(item.id);
                      setState(() {
                        _notificationsPagingController.itemList!
                            .removeAt(index);
                      });
                    },
                    key: ValueKey(item),
                    child: NotificationItem(notification: item)),
                firstPageProgressIndicatorBuilder: (_) => const Center(child: MyProgress()),
                firstPageErrorIndicatorBuilder: (context) {
                  return Center(
                      child: Text('${_notificationsPagingController.error}'));
                },
                noItemsFoundIndicatorBuilder: (context) => const Center(
                      child: SizedBox.shrink(),
                      // EmptyWidget(text: 'You have not any notifications'),
                    ),
                newPageProgressIndicatorBuilder: (_) => const Center(child: MyProgress())),
          )),
    );
  }

  /// ////////////////////////////////
  /// ////// Helper Widgets //////////
  /// ///////////////////////////////
  AppBar _appBar() => AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(LocaleKeys.notifications.tr()),
      );

  Widget _customDivider() => Padding(
      padding: EdgeInsets.only(
        bottom: 10.h,
      ),
      child: const Divider(color: Color(0xffE0E0E0)));

  /// ////////////////////////////////
  /// ///////// Helper Methods ////////
  /// ////////////////////////////////

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            _showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < 3) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        // _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void _showAdvSnackBar(){
   WidgetsBinding.instance.addPostFrameCallback((_) {
     AppFunctions.showAdvSnackBar(context);
   });
  }
}
