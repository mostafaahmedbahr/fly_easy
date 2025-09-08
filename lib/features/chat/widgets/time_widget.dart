import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:intl/intl.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({Key? key,required this.dateTime}) : super(key: key);
final DateTime dateTime;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Text(
        DateFormat.jm().format(dateTime),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontFamily: AppFonts.arial,
            fontSize: 11.sp,
            fontWeight: FontWeight.w400),
      ),
    );
  }



}
