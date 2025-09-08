import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    Key? key,
    required this.controller,
    required this.onChange,
  }) : super(key: key);

  final TextEditingController controller;
  final void Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 16.sp, fontWeight: FontWeight.w600, letterSpacing: .8),
      cursorColor: Theme.of(context).indicatorColor,
      maxLines: null,

      decoration: InputDecoration(
          border: _border(),
          enabledBorder: _border(),
          disabledBorder: _border(),
          focusedBorder: _border(),
          hintText: LocaleKeys.write_your_message.tr(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: AppFonts.lato,
              letterSpacing: 1),
          filled: true,
          fillColor: CacheUtils.isDarkMode()
              ? Theme.of(context).scaffoldBackgroundColor
              : const Color(0xffF3F6F6)),
      onChanged: onChange,
    );
  }

  OutlineInputBorder _border() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(50.r),
      borderSide: const BorderSide(color: Colors.transparent));
}
