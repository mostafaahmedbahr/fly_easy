import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/ad_mob/ad_mob_service.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/features/library/screens/views/sections_view.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalAppCubit, GlobalAppState>(
      builder: (context, state) => Scaffold(
          appBar: _appBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Text(
                    LocaleKeys.adv_space.tr(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14.sp),
                  )),
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
              const Expanded(child: SectionsView()),
            ],
          )),
    );
  }

  AppBar _appBar() => AppBar(
        title: Text(LocaleKeys.library.tr()),
        centerTitle: true,
      );

  // void _onAddChannelPressed() {
  //   _checkChannelsCharge()
  //       ? LayoutCubit.get(context).showAddChannelSheet()
  //       : context.push(Routes.plans);
  // }

  bool _checkChannelsCharge() {
    return (HiveUtils.getUserData()!.remainsTeamsCount > 0);
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
}
