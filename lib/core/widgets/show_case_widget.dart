import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowCase extends StatelessWidget {
  const CustomShowCase({
    super.key,
    required this.child,
    required this.description,
    required this.caseKey,
    this.title,
  });
  final Widget child;
  final GlobalKey? caseKey;
  final String description;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if(caseKey!=null){
      return Showcase(
        key: caseKey!,
        description: description,
        targetPadding: const EdgeInsets.all(5),
        title: title,
        titleAlignment: Alignment.center,
        descriptionAlignment: Alignment.center,
        tooltipBackgroundColor: Colors.lightBlue,
        tooltipBorderRadius: BorderRadius.circular(10),
        targetBorderRadius: BorderRadius.circular(10),
        descTextStyle: TextStyle(color: Colors.white,fontSize: 18.sp),
        titleTextStyle: TextStyle(color: Colors.black,fontSize: 20.sp),
        child: child,
      );
    }else{
      return  SizedBox(child: child,);
    }
  }
}
