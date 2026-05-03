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
  String _currentText = '';

  @override
  void initState() {
    obscure = widget.obSecure;
    _currentText = widget.controller?.text ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            onChanged: (value) {
              // Update local text variable and trigger rebuild
              setState(() {
                _currentText = value ?? '';
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            autofillHints: widget.autoFills,
            obscureText: obscure,
            onFieldSubmitted: widget.onSubmit,
          ),
        ),
        // Validation messages - only for password field in register page
        if (_isRegisterPasswordField())
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Password length validation
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Row(
                  children: [
                    Icon(
                      _isPasswordLengthValid()
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color: _isPasswordLengthValid()
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'At least 8 characters',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _isPasswordLengthValid()
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Password uppercase validation
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Row(
                  children: [
                    Icon(
                      _hasUppercaseLetter()
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color: _hasUppercaseLetter() ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Contains uppercase letter',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _hasUppercaseLetter()
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Password lowercase validation
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Row(
                  children: [
                    Icon(
                      _hasLowercaseLetter()
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color: _hasLowercaseLetter() ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Contains lowercase letter',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _hasLowercaseLetter()
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Password number validation
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Row(
                  children: [
                    Icon(
                      _hasNumber()
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color: _hasNumber() ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Contains number',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _hasNumber() ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Password special character validation
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Row(
                  children: [
                    Icon(
                      _hasSpecialCharacter()
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color: _hasSpecialCharacter() ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Contains special character',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: _hasSpecialCharacter()
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  // Helper method to check if this is a password field in register page only (not login)
  bool _isRegisterPasswordField() {
    final hint = widget.hint.toLowerCase();
    // Must contain password AND strong register-specific indicators only
    return hint.contains('password') &&
        (hint.contains('confirm') ||
            hint.contains('create') ||
            hint.contains('sign up') ||
            hint.contains('register'));
  }

  // Password validation helpers
  bool _isPasswordLengthValid() {
    return _currentText.length >= 8;
  }

  bool _hasUppercaseLetter() {
    return _currentText.contains(RegExp(r'[A-Z]'));
  }

  bool _hasLowercaseLetter() {
    return _currentText.contains(RegExp(r'[a-z]'));
  }

  bool _hasNumber() {
    return _currentText.contains(RegExp(r'[0-9]'));
  }

  bool _hasSpecialCharacter() {
    return _currentText.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  OutlineInputBorder _border() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(22)),
      borderSide: BorderSide(color: Colors.transparent),
    );
  }
}
