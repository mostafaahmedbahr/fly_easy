import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({Key? key, required this.dateTime}) : super(key: key);
  final Timestamp dateTime;

  @override
  Widget build(BuildContext context) {
    String date = DateFormat.yMEd().format(dateTime.toDate());
    bool isToday = DateFormat.yMEd().format(dateTime.toDate()) ==
        DateFormat.yMEd().format(DateTime.now());
    return Text(
        isToday ? LocaleKeys.today.tr() : date,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        fontFamily: AppFonts.arial),);
  }
}
