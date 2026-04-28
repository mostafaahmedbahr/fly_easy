import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
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
    this.obSecure = false,
  }) : super(key: key);
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscure = true;

  @override
  void initState() {
    obscure = widget.obSecure;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 22.05,
            offset: Offset(0, 8.82),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        autofocus: widget.autoFocus,
        enabled: widget.enabled,
        controller: widget.controller,
        cursorColor: Theme.of(context).indicatorColor,
        maxLines: widget.maxLines,
        keyboardType: widget.inputType ?? TextInputType.text,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 22,
            horizontal: 10,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(),
          disabledBorder: _border(),
          prefixIcon: widget.prefixIcon,
          suffixIcon:
              widget.suffix ??
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
          ),
        ),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: .8,
        ),
        onSaved: widget.onSave,
        validator: widget.validator,
        onChanged: widget.onChanged,
        autofillHints: widget.autoFills,
        obscureText: obscure,
        onFieldSubmitted: widget.onSubmit,
      ),
    );
  }

  OutlineInputBorder _border() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(22)),
      borderSide: BorderSide(color: Colors.transparent),
    );
  }
}
