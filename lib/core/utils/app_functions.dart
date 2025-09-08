import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class AppFunctions {
  const AppFunctions();

  static void showMySnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(fontSize: 18, color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsetsDirectional.symmetric(vertical: 10.h, horizontal: 8.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
    ));
  }

  static void showAdvSnackBar(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.adv_will_appear_now.tr(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
          ),
          SizedBox(width: 10.w,),
           SizedBox(width: 20.w,height: 20.w,child: const MyProgress(color: Colors.white,stroke: .2,)),
        ],
      ),
      backgroundColor: AppColors.lightSecondaryColor,
      margin: EdgeInsets.symmetric(horizontal: 10.w,vertical: 15.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 8.h),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    ));
  }
  static void showToast({required String message, required ToastStates state}) =>
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: _chooseToastColor(state),
          textColor: Colors.white,
          fontSize: 16.sp);

  static Future<void> showAdaptiveDialog(BuildContext context,
      {required String title,
      required String actionName,
        String? cancelName,
      required void Function() onPress}) async {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(
                  color: CacheUtils.isDarkMode() ? Colors.white : Colors.black),
            ),
            elevation: 5,
            shadowColor:CacheUtils.isDarkMode()? Colors.black:Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  cancelName??
                  LocaleKeys.cancel.tr(),
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: () {
                  onPress();
                  context.pop();
                },
                child: Text(
                  actionName,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).indicatorColor),
                ),
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title,
              style: TextStyle(
                  color:
                      CacheUtils.isDarkMode() ? Colors.white : Colors.black)),
          insetAnimationCurve: Curves.ease,
          insetAnimationDuration: const Duration(microseconds: 600),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(cancelName??LocaleKeys.cancel.tr()),
              onPressed: () => context.pop(),
            ),
            CupertinoDialogAction(
              onPressed: () {
                onPress();
                context.pop();
              },
              child: Text(
                // LocaleKeys.accept.tr()
                actionName,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).indicatorColor),
              ),
            )
          ],
        ),
      );
    }
  }

  static Color _chooseToastColor(ToastStates state) {
    switch (state) {
      case ToastStates.error:
        return Colors.black;
      case ToastStates.success:
        return Colors.green;
      case ToastStates.warning:
        return Colors.amber;
    }
  }
}
