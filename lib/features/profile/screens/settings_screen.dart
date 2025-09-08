import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/dialog_progress_indicator.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/core/widgets/show_case_widget.dart';
import 'package:new_fly_easy_new/features/profile/bloc/profile_cubit.dart';
import 'package:new_fly_easy_new/features/profile/widgets/icon_back_ground.dart';
import 'package:new_fly_easy_new/features/profile/widgets/info_widget.dart';
import 'package:new_fly_easy_new/features/profile/widgets/language_dialog.dart';
import 'package:new_fly_easy_new/features/profile/widgets/qr_dialog.dart';
import 'package:new_fly_easy_new/features/profile/widgets/settings_item.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileCubit get cubit => ProfileCubit.get(context);
  GlobalKey? _howToUseHintKey;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = CacheUtils.isDarkMode();
    _startShowCase();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: _listener,
      child: Scaffold(
        appBar: _appBar(),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          children: [
            const InfoWidget(),
            SizedBox(
              height: 20.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              decoration: ShapeDecoration(
                color: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.09),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 35.16,
                    offset: Offset(0, 20.09),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  SettingTile(
                    title: LocaleKeys.edit_your_profile.tr(),
                    subTitle: LocaleKeys.update_your_name_and_photo.tr(),
                    icon: AppIcons.edit,
                    onTab: () {
                      sl<AppRouter>()
                          .navigatorKey
                          .currentState!
                          .pushNamed(Routes.editProfile, arguments: cubit);
                    },
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SettingTile(
                    title: LocaleKeys.user_qr_code.tr(),
                    subTitle: LocaleKeys.get_yor_qr.tr(),
                    icon: Icons.qr_code,
                    onTab: _showQrDialog,
                  ),
                  // SizedBox(
                  //   height: 15.h,
                  // ),
                  // SettingTile(
                  //   title: LocaleKeys.pricing_and_plans.tr(),
                  //   subTitle: LocaleKeys.grow_up_yor_communities.tr(),
                  //   icon: Icons.monetization_on_outlined,
                  //   onTab: () {
                  //     sl<AppRouter>()
                  //         .navigatorKey
                  //         .currentState!
                  //         .pushNamed(Routes.plans);
                  //   },
                  // ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomShowCase(
                    description: AppStrings.howToUseHint,
                    caseKey: _howToUseHintKey,
                    child: SettingTile(
                      title: LocaleKeys.how_to_use.tr(),
                      subTitle: LocaleKeys.know_how_to_benefit.tr(),
                      icon: Icons.video_collection_rounded,
                      onTab: () {
                        _launchHowToUseVideo(
                            'https://youtu.be/hJlWkN7Iz_o?si=9sT-d0EMVXgDkzuS');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SettingTile(
                    title: LocaleKeys.language.tr(),
                    subTitle: LocaleKeys.change_your_language.tr(),
                    icon: Icons.language,
                    onTab: () {
                      _showLanguageDialog();
                    },
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => Row(
                      children: [
                        IconBackGround(
                          icon: Icon(
                            Icons.dark_mode_outlined,
                            color: Theme.of(context).indicatorColor,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.dark_mode.tr(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isDarkMode,
                          onChanged: (value) async {
                            await GlobalAppCubit.get(context).changeTheme(value);
                            setState(() {
                              isDarkMode = value;
                            });
                          },
                          activeColor: AppColors.lightPrimaryColor,
                          inactiveThumbColor: const Color(0xffB3B9C2),
                          inactiveTrackColor: Colors.transparent,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          trackOutlineWidth:
                              const MaterialStatePropertyAll(1.5),
                          trackOutlineColor:
                              const MaterialStatePropertyAll(Color(0xffB3B9C2)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SettingTile(
                    title: LocaleKeys.delete_your_account.tr(),
                    subTitle: '',
                    icon: AppIcons.delete,
                    onTab: _showDeleteAccountDialog,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Align(
              alignment: Alignment.center,
              child: BlocConsumer<ProfileCubit, ProfileState>(
                buildWhen: (previous, current) =>
                    current is LogoutLoad ||
                    current is LogoutSuccess ||
                    current is LogoutError,
                listener: (context, state) {
                  if (state is LogoutSuccess) {
                    ZegoUIKitPrebuiltCallInvitationService().uninit();
                  }
                },
                builder: (context, state) => CustomButton(
                    width: context.width * .4,
                    onPress: () {
                      ProfileCubit.get(context).logout();
                    },
                    buttonType: 1,
                    child: state is LogoutLoad
                        ? const MyProgress(
                            color: Colors.white,
                          )
                        : ButtonText(title: LocaleKeys.logout.tr())),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }

  /// /////////////////////////////////////////
  /// ///////////// Helper Methods ///////////////
  /// ///////////////////////////////////////////

  AppBar _appBar() => AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new))
            : null,
        title: Text(LocaleKeys.profile.tr()),
        centerTitle: true,
      );

  void _showQrDialog() {
    showDialog(
      context: context,
      builder: (context) => const QrDialog(),
    );
  }

  void _listener(BuildContext context, ProfileState state) {
    if (state is LogoutSuccess) {
      sl<AppRouter>()
          .navigatorKey
          .currentState!
          .pushNamedAndRemoveUntil(Routes.welcome, (route) => false);
    } else if (state is PickImagesSuccess) {
      context.pop();
    } else if (state is UpdateImageError) {
      Navigator.of(context, rootNavigator: true).pop();
      AppFunctions.showToast(message: state.error, state: ToastStates.error);
    } else if (state is UpdateImageSuccess) {
      GlobalAppCubit.get(context).refreshUserImage();
      Navigator.of(context, rootNavigator: true).pop();
      AppFunctions.showToast(
          message: LocaleKeys.image_updated_success.tr(),
          state: ToastStates.error);
    } else if (state is UpdateImageLoad) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const DialogIndicator(),
      );
    } else if (state is DeleteAccountLoad) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const DialogIndicator(),
      );
    }else if(state is DeleteAccountSuccess){
      Navigator.of(context, rootNavigator: true).pop();
      sl<AppRouter>()
          .navigatorKey
          .currentState!
          .pushNamedAndRemoveUntil(Routes.welcome, (route) => false);
      AppFunctions.showToast(message: 'Your Account Deleted Successfully', state: ToastStates.error);
    }else if(state is DeleteAccountError){
      Navigator.of(context, rootNavigator: true).pop();
      AppFunctions.showToast(message: state.error, state: ToastStates.error);
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => const LanguageDialog(),
    );
  }

  void _showDeleteAccountDialog() {
    AppFunctions.showAdaptiveDialog(
      context,
      title: LocaleKeys.do_you_want_delete_account.tr(),
      actionName: LocaleKeys.delete.tr(),
      onPress: () {
        cubit.deleteUserAccount();
      },
    );
  }

  Future<void> _launchHowToUseVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    }
  }

  void _startShowCase() {
    if (!CacheUtils.isHowToUseHintShown()) {
      _howToUseHintKey = GlobalKey();
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([_howToUseHintKey!]));
      CacheUtils.setHowToUseHint();
    }
  }
}
