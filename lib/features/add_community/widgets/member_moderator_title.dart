import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/add_member_button.dart';

class MemberModeratorTitle extends StatelessWidget {
  const MemberModeratorTitle(
      {Key? key, required this.title, required this.onAddPressed})
      : super(key: key);
  final String title;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.poppins),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: AddMemberButton(
              onTab: onAddPressed,
            ),
          ),
        ],
      ),
    );
  }
}
