import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/widgets/custom_network_image.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';

class GuestItem extends StatelessWidget {
  const GuestItem({Key? key,required this.member}) : super(key: key);
final MemberModel member;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      type: MaterialType.circle,
      color: Colors.white,
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 55.w,
        padding: EdgeInsets.all(3.w),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle
        ),
        child: CustomNetworkImage(
          width: 45.w,
          imageUrl:member.image,
        ),
      ),
    );
  }
}
