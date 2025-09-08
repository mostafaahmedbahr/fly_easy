import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';

class InactiveButton extends StatelessWidget {
  const InactiveButton({Key? key, required this.width, required this.title})
      : super(key: key);
  final double width;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      width: width,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: AppColors.lightPrimaryColor.withOpacity(.2),
          borderRadius: BorderRadius.circular(20.r)),
      child: title,
    );
  }
}
