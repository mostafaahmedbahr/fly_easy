import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {Key? key, required this.onChange, required this.hint,this.controller,this.isEnabled=true })
      : super(key: key);
  final Function(String? value) onChange;
  final TextEditingController? controller;
  final String hint;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(!isEnabled){
          context.push(Routes.search);
        }
      },
      child: TextFormField(
        controller: controller,
        enabled: isEnabled,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.bodySmall,
            size: 25.sp,
          ),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
          filled: true,
          fillColor: CacheUtils.isDarkMode()
              ? Theme.of(context).cardColor
              : const Color(0xffEEF1F4),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(),
          disabledBorder: _border(),
        ),
        cursorHeight: 20.h,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Theme.of(context).indicatorColor,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: .8,
            color: Theme.of(context).primaryColorDark,
            fontFamily: AppFonts.mulish),
        onChanged: onChange,
      ),
    );
  }

  OutlineInputBorder _border() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: const BorderSide(color: Colors.transparent));
}
