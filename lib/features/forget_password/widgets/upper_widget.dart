import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

class UpperWidget extends StatelessWidget {
  const UpperWidget(
      {Key? key,
      required this.title,
      required this.imagePath,
      required this.subTitle})
      : super(key: key);
  final String imagePath;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 98.47,
          height: 98.47,
          padding: const EdgeInsets.all(10.94),
          decoration: ShapeDecoration(
            color: const Color(0xFFD6DFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27.35),
            ),
          ),
          child: Image.asset(
            imagePath,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 35.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.poppins),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          subTitle,
          textAlign: TextAlign.center,
          style:  Theme.of(context).textTheme.labelSmall,
        ),
        SizedBox(height: 20.h,),
      ],
    );
  }
}
