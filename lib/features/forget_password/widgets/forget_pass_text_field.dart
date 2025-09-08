import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

class ForgetPassTextField extends StatefulWidget {
  const ForgetPassTextField(
      {Key? key,
      required this.hint,
      this.onChanged,
      this.fillColor,
      this.controller,
      this.onSave,
      this.validator,
      this.autoFills,
      this.maxLines = 1,
      this.inputType,
      this.suffix,
      this.enabled = true,
      this.autoFocus = false,
      this.prefixIcon,
      this.onSubmit,
      this.obSecure = false})
      : super(key: key);
  final String hint;
  final Color? fillColor;
  final int? maxLines;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final bool obSecure;
  final void Function(String?)? onSave;
  final String? Function(String?)? validator;
  final Iterable<String>? autoFills;
  final Widget? suffix;
  final bool enabled;
  final bool autoFocus;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmit;

  @override
  State<ForgetPassTextField> createState() => _ForgetPassTextFieldState();
}

class _ForgetPassTextFieldState extends State<ForgetPassTextField> {
  ThemeData get theme => Theme.of(context);
  bool obscure = true;

  @override
  void initState() {
    obscure = widget.obSecure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autoFocus,
      enabled: widget.enabled,
      controller: widget.controller,
      cursorColor: theme.indicatorColor,
      maxLines: widget.maxLines,
      keyboardType: widget.inputType ?? TextInputType.text,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
          filled: true,
          fillColor: CacheUtils.isDarkMode()
              ? theme.cardColor
              : const Color(0xffF5F9FE),
          border: _border(),
          enabledBorder: _enabledBorder(),
          focusedBorder: _enabledBorder(),
          disabledBorder: _border(),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffix ??
              (widget.obSecure
                  ? IconButton(
                      enableFeedback: false,
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        obscure ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.textFieldIconColor,
                      ),
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                    )
                  : null),
          hintText: widget.hint,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            fontFamily: AppFonts.lato,
            color: AppColors.hintTextColor,
          )),
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 16.sp, fontWeight: FontWeight.w600, letterSpacing: .8),
      onSaved: widget.onSave,
      validator: widget.validator,
      onChanged: widget.onChanged,
      autofillHints: widget.autoFills,
      obscureText: obscure,
      onFieldSubmitted: widget.onSubmit,
    );
  }

  OutlineInputBorder _border() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
        borderSide: const BorderSide(color: Colors.transparent));
  }

  OutlineInputBorder _enabledBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
        borderSide: BorderSide(
            color: CacheUtils.isDarkMode()
                ? Colors.white
                : const Color(0xff3461FD)));
  }
}
