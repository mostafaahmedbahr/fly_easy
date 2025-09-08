import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class NameFormField extends StatelessWidget {
  const NameFormField({Key? key,required this.onSave,required this.validator,required this.controller}) : super(key: key);
  final void Function(String?)? onSave;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Theme.of(context).indicatorColor,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        fontFamily: AppFonts.poppins,
        color: Theme.of(context).primaryColorDark,
      ),
      decoration:  InputDecoration(
        hintText: LocaleKeys.enter_community_name.tr(),
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.sp,fontWeight: FontWeight.w400),
        contentPadding:  EdgeInsets.symmetric(vertical: 0,horizontal:10.w),
        enabledBorder: _border(context),
        border: _border(context),
        disabledBorder:  _border(context),
        focusedBorder:  _border(context),
      ),
      onSaved: onSave,
      validator: validator,
    );
  }

  UnderlineInputBorder _border(BuildContext context)=> UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColorDark));
}
