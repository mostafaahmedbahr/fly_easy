import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:lottie/lottie.dart';

class NoChargeDialog extends StatelessWidget {
  const NoChargeDialog({Key? key,required this.message}) : super(key: key);
final String message;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).cardColor,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              AppImages.noCharge,
              repeat: false,
            ),
            SizedBox(height: 25.h,),
            Text(message,style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600,),textAlign: TextAlign.center),
            SizedBox(height: 15.h,),
            CustomButton(width: context.width*.6, onPress: () {
              context.pop();
              sl<AppRouter>().navigatorKey.currentState!.pushNamed(Routes.plans);
            }, buttonType: 1, child:  ButtonText(title: LocaleKeys.see_our_plans.tr()))
          ],
        ),
      ),
    );
  }
}
