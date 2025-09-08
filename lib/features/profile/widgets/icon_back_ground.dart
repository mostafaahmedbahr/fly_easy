import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';

class IconBackGround extends StatelessWidget {
  const IconBackGround({Key? key,required this.icon}) : super(key: key);
final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40.w,
        height: 40.w,
        alignment: Alignment.center,
        padding: EdgeInsets.all(5.w),
        decoration: ShapeDecoration(
          color: CacheUtils.isDarkMode()
              ? AppColors.darkIconBackGround
              : AppColors.lightIconBackGround,
          shape: const OvalBorder(),
        ),
        child:icon,
    );
  }
}
