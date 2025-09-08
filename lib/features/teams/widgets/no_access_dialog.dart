import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class NoAccessDialog extends StatelessWidget {
  const NoAccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.password,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 15.h,),
             Text(LocaleKeys.sorry.tr(),style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.w900,),textAlign: TextAlign.center,),
            SizedBox(height: 5.h,),
            Text(LocaleKeys.you_have_no_access.tr(),style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700,),textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
