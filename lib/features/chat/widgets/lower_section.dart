import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/ad_mob/ad_mob_service.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/chat_text_field.dart';
import 'package:new_fly_easy_new/features/chat/widgets/recorder/recorder.dart';
import 'package:new_fly_easy_new/features/chat/widgets/share_bottom_sheet.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uuid/uuid.dart';

class LowerSection extends StatefulWidget {
  const LowerSection({Key? key}) : super(key: key);

  @override
  State<LowerSection> createState() => _LowerSectionState();
}

class _LowerSectionState extends State<LowerSection> {
  final TextEditingController _controller = TextEditingController();

  ChatCubit get cubit => ChatCubit.get(context);
  bool isRecording = false;
  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height:  context.height * .1,
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: _showShareContentSheet,
                  icon: Icon(
                    Icons.attach_file_outlined,
                    size: 22.sp,
                  )),
              Expanded(
                  child: ChatTextField(
                      onChange: (value) => setState(() {}),
                      controller: _controller)),
              _controller.text.isNullOrEmpty
                  ?  const Recorder()
                  : IconButton(
                      onPressed: () {
                        if (cubit.teamId != null) {
                          cubit.sendTeamTextMessage(MessageModel(
                              senderId: HiveUtils.getUserData()!.id,
                              senderImage: HiveUtils.getUserData()!.image,
                              senderName: HiveUtils.getUserData()!.name,
                              text: _controller.text,
                              virtualId: sl<Uuid>().v1(),
                              type: _controller.text.startsWith('https')
                                  ? MessageType.link.name
                                  : MessageType.text.name,
                              dateTime: Timestamp.now()));
                        } else {
                          cubit.sendTextMessage(MessageModel(
                              senderId: HiveUtils.getUserData()!.id,
                              senderImage: HiveUtils.getUserData()!.image,
                              senderName: HiveUtils.getUserData()!.name,
                              text: _controller.text,
                              virtualId: sl<Uuid>().v1(),
                              type: _controller.text.startsWith('https')
                                  ? MessageType.link.name
                                  : MessageType.text.name,
                              dateTime: Timestamp.now()));
                        }
                        setState(() {
                          _controller.clear();
                        });
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                      style: ButtonStyle(
                          shape: const MaterialStatePropertyAll(CircleBorder()),
                          backgroundColor: MaterialStatePropertyAll(
                              CacheUtils.isDarkMode()
                                  ? AppColors.lightSecondaryColor
                                  : AppColors.lightPrimaryColor),
                          padding: MaterialStatePropertyAll(EdgeInsets.all(5.w))),
                    ),
            ],
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

  /// ///////////////////////////////////
  /// //////////// Helper Methods ///////
  /// ////////////////////////////////////

  void _showShareContentSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
      builder: (context) => FractionallySizedBox(
          heightFactor: .65,
          child: ShareBottomSheet(
            chatCubit: cubit,
          )),
    );
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId!,
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
          onAdClosed: (ad) {
            ad.dispose();
          },
          onAdLoaded: (ad) {
            setState(() {
              _bannerAdLoaded = true;
            });
          },
        ),
        request: const AdRequest())
      ..load();
  }

}
