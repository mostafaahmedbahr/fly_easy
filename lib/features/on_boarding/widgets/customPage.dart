import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

class CustomPage extends StatelessWidget {
  const CustomPage(
      {Key? key,
      required this.title,
      required this.image,
      required this.description})
      : super(key: key);
  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w,right: 15.w,top: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              image,
              height: context.height * .4,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Text(
            title,
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 25.sp),
          ),
          SizedBox(
            height: 15.h,
          ),
          Text(
            description,
            textAlign: TextAlign.start,
            maxLines: 10,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 16.sp,
              color: const Color(0xFF2D2B2E).withOpacity(.6),
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
