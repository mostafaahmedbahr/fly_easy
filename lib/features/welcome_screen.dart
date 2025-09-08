import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/features/widgets/terms_and_conditions_dialog.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  ThemeData get themeData => Theme.of(context);

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showConditionsDialog(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSecondaryColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 15.h, left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  AppImages.teamsImage,
                  fit: BoxFit.cover,
                  height: context.height * .25,
                  width: context.width*.85,
                ),
              ],
            ),
            // Text(
            //   'Layered',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //       fontSize: 28.sp,
            //       fontWeight: FontWeight.w600,
            //       color: Colors.white),
            // ),
            SizedBox(
              height: 10.h,
            ),
            Image.asset(
              AppImages.onBoardingImage,
              fit: BoxFit.contain,
              height: context.height * .25,
              width: context.width * .8,
            ),
            Text(
              'Vibrant communication \nSmarter teamwork',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomButton(
                  onPress: () {
                    context.pushAndRemove(Routes.login);
                  },
                  width: double.infinity,
                  buttonType: 1,
                  color: AppColors.lightPrimaryColor,
                  child: Text(
                    LocaleKeys.log_in.tr(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500),
                  )),
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomButton(
                  onPress: () {
                    context.pushAndRemove(Routes.register);
                  },
                  buttonType: 2,
                  width: double.infinity,
                  child: Text(
                    LocaleKeys.sign_up.tr(),
                    style: TextStyle(
                        color: AppColors.lightPrimaryColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500),
                  )),
            ),
            SizedBox(height: 20.h,)
          ],
        ),
      ),
    );
  }

  void _showConditionsDialog(BuildContext context) {
    if (!CacheUtils.isAcceptConditions()) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const TermsAndConditionsDialog(),
      );
    }
  }
}
