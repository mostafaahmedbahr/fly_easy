import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/add_community_button.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:iconly/iconly.dart';

class TeamFloatingRowButtons extends StatelessWidget {
  const TeamFloatingRowButtons(
      {super.key,
      required this.isAdmin,
      required this.teamModel,
      required this.onAddCommunityPressed,
      required this.onChatPressed,
      required this.onDuplicatePressed});

  final bool isAdmin;
  final TeamModel teamModel;
  final VoidCallback onChatPressed;
  final VoidCallback onDuplicatePressed;
  final VoidCallback onAddCommunityPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: isAdmin,
          replacement: const SizedBox.shrink(),
          child: TeamFloatingButton(
            color: AppColors.lightSecondaryColor,
            icon: Icons.add,
            onPress: onAddCommunityPressed,
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        Visibility(
          visible: isAdmin,
          replacement: const SizedBox.shrink(),
          child: TeamFloatingButton(
              color: AppColors.darkIconBackGround,
              onPress: onDuplicatePressed,
              icon: Icons.copy),
        ),
        SizedBox(
          width: 5.w,
        ),
        TeamFloatingButton(
            color: AppColors.lightPrimaryColor,
            onPress: onChatPressed,
            icon: IconlyLight.chat)
      ],
    );
  }}
