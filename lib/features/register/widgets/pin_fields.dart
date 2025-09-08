import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeFields extends StatelessWidget {
  const PinCodeFields(
      {Key? key,
      required this.context,
      required this.onSave,
      required this.controller,
      required this.onChange})
      : super(key: key);
  final BuildContext context;
  final Function(String? value) onSave;
  final Function(String? value) onChange;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      obscureText: false,
      autoFocus: true,
      controller: controller,
      cursorColor: Colors.black,
      animationType: AnimationType.scale,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50.h,
        fieldWidth: 40.w,
        borderWidth: 1,
        activeFillColor: AppColors.lightPrimaryColor.withOpacity(.2),
        activeColor: AppColors.lightPrimaryColor,
        // for active border
        inactiveColor: AppColors.lightPrimaryColor,
        // for inactive border
        inactiveFillColor: const Color(0xffF8FAFC),
        selectedColor: Theme.of(context).indicatorColor,
        selectedFillColor: const Color(0xffF5F7FF),
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      // onCompleted: (code) {
      //   sl<BaseAuthRepository>().otpSubmitted=code;
      // },
      onSaved: onSave,
      onChanged: onChange,
    );
  }
}
