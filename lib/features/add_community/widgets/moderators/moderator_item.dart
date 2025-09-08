import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/custom_network_image.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({Key? key, required this.member, this.isModerator = true,this.isAdmin=false})
      : super(key: key);
  final MemberModel member;
  final bool? isModerator;
  final bool? isAdmin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomNetworkImage(
          width: 45.w,
          imageUrl: member.image,
        ),
        8.w.width,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              member.name,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.poppins,
                  fontSize: 16),
            ),
            Text(
              isAdmin!?
                  LocaleKeys.community_admin.tr():
              isModerator!
                  ? LocaleKeys.community_moderator.tr()
                  : LocaleKeys.community_member.tr(),
              style: TextStyle(
                color: Theme.of(context).primaryColorDark.withOpacity(.5),
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
              ),
            )
          ],
        )
      ],
    );
  }
}
