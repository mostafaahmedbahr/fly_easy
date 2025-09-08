import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';

class ProgressWidget extends StatefulWidget {
  ProgressWidget({Key? key, this.isActive = false}) : super(key: key);
  bool isActive;

  @override
  State<ProgressWidget> createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.01,
      height: 4.38,
      decoration: ShapeDecoration(
        color: widget.isActive
            ? AppColors.lightPrimaryColor
            : const Color(0xFFD6DFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.19),
        ),
      ),
    );
  }
}
