import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key, required this.text, required this.image,this.repeat})
      : super(key: key);
  final String text;
  final String image;
  final bool? repeat;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            image,
            repeat: repeat??true,
          ),
          SizedBox(height: 10.h,),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 22, color: AppColors.lightSecondaryColor,fontFamily: AppFonts.poppins),
          )
        ],
      ),
    );
  }
}
