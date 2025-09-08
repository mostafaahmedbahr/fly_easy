import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.child,
    required this.width,
    required this.onPress,
    required this.buttonType,
    this.color,
  }) : super(key: key);
  final Widget child;
  final double width;
  final int buttonType;
  final Color? color;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55.h,
      width: width,
      child: ElevatedButton(
        onPressed: onPress,
        style: color != null
            ? Theme.of(context)
                .elevatedButtonTheme
                .style!
                .copyWith(backgroundColor: MaterialStatePropertyAll(color))
            : buttonType == 1
                ? Theme.of(context).elevatedButtonTheme.style
                : Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor: const MaterialStatePropertyAll(
                        AppColors.elevatedButtonSecondColor),
                    textStyle: const MaterialStatePropertyAll(
                        TextStyle(color: AppColors.lightPrimaryColor))),
        child: child,
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  const ButtonText({Key? key, required this.title, this.titleColor})
      : super(key: key);
  final String title;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: titleColor ?? Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500),
    );
  }
}
