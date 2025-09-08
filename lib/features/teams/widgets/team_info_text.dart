import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/teams/widgets/team_name_with_edit_icon.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:iconly/iconly.dart';

class TeamInfoText extends StatelessWidget {
  const TeamInfoText(
      {super.key,
      required this.team,
      required this.isOpened,
      required this.showEditBottomSheet});

  final bool isOpened;
  final TeamModel team;
  final VoidCallback showEditBottomSheet;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeamNameWithEditIcon(
            showEditBottomSheet: showEditBottomSheet, team: team),
        Text(
          '${LocaleKeys.members.tr()}: ${team.membersNumber}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          '${LocaleKeys.groups.tr()}: ${team.groupsNumber}',
          style:
              Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
        ),
        Visibility(
            visible: team.communities.isNotEmpty && !isOpened,
            replacement: const SizedBox.shrink(),
            child: const Icon(IconlyBroken.arrow_down_2))
      ],
    );
  }
}
