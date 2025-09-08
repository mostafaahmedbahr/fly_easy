import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';

class TeamNameWithEditIcon extends StatelessWidget {
  const TeamNameWithEditIcon(
      {super.key,
      required this.showEditBottomSheet,
      required this.team,
      this.isArchive = false});

  final TeamModel team;
  final bool isArchive;
  final VoidCallback showEditBottomSheet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
          team.name,
          style: Theme.of(context).textTheme.bodyMedium,
        )),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 15.w),
          child: Visibility(
            visible: (team.type != UserType.guest.name && !isArchive),
            replacement: const SizedBox.shrink(),
            child: InkWell(
                enableFeedback: true,
                borderRadius: BorderRadius.circular(20),
                onTap: showEditBottomSheet,
                child: const Icon(AppIcons.edit)),
          ),
        )
      ],
    );
  }
}
