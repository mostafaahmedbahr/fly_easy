import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/teams/models/community_model.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';

class SubCommunityItem extends StatelessWidget {
  const SubCommunityItem({
    Key? key,
    required this.onPressEdit,
    required this.onPressChat,
    required this.onPressDelete,
    required this.communityModel,
    this.isArchive = false,
  }) : super(key: key);
  final CommunityModel communityModel;
  final void Function()? onPressEdit;
  final void Function()? onPressChat;
  final void Function()? onPressDelete;
  final bool isArchive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: onPressChat,
            child: Text(
              communityModel.name,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.lightSecondaryColor),
            )),
        SizedBox(
          width: 10.w,
        ),
        Visibility(
          visible: communityModel.type != UserType.guest.name && !isArchive,
          replacement: const SizedBox.shrink(),
          child: IconButton(
              onPressed: onPressEdit, icon: const Icon(AppIcons.edit)),
        ),
        Visibility(
          visible:communityModel.type == UserType.admin.name||communityModel.type==null ,
            child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed:onPressDelete,
        ))
      ],
    );
  }
}
