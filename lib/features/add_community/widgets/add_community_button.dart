import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamFloatingButton extends StatelessWidget {
  const TeamFloatingButton(
      {Key? key,
      required this.color,
      required this.onPress,
      required this.icon})
      : super(key: key);
  final Color color;
  final IconData icon;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(),
      child: Container(
        width: 48.w,
        height: 48.w,
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }
}
