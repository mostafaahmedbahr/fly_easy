import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ChargeCounterTitle extends StatelessWidget {
  const ChargeCounterTitle({Key? key,required this.onUpgradePressed}) : super(key: key);
final VoidCallback onUpgradePressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              LocaleKeys.remaining.tr(),
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700),
            ),
          ),
          // TextButton(
          //     onPressed: onUpgradePressed,
          //     style: const ButtonStyle(
          //       padding: MaterialStatePropertyAll(EdgeInsets.zero)
          //     ),
          //     child: Row(
          //       children: [
          //         Text(
          //           LocaleKeys.upgrade_now.tr(),
          //           style: Theme.of(context)
          //               .textTheme
          //               .titleSmall!
          //               .copyWith(fontSize: 14.sp),
          //         ),
          //         Icon(
          //           Icons.arrow_forward_ios,
          //           color: Theme.of(context)
          //               .primaryColor,
          //           size: 18,
          //         )
          //       ],
          //     ))
        ],
      ),
    );
  }
}
