import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/teams/models/community_model.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';

class SubCommunityItem extends StatefulWidget {
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
  State<SubCommunityItem> createState() => _SubCommunityItemState();
}

class _SubCommunityItemState extends State<SubCommunityItem> {
  int notificationsNum = 0;

  @override
  void initState() {
    super.initState();
    notificationsNum = widget.communityModel.notificationsCount;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalAppCubit, GlobalAppState>(
      listenWhen: (previous, current) =>
          (current is ReceiveTeamNotification &&
              current.teamId.toString() == widget.communityModel.id.toString()) ||
          (current is ClearTeamChatNotifications &&
              current.teamId.toString() == widget.communityModel.id.toString()),
      listener: (context, state) {
        if (state is ReceiveTeamNotification) {
          setState(() => notificationsNum++);
        } else if (state is ClearTeamChatNotifications) {
          setState(() => notificationsNum = 0);
        }
      },
      child: Row(
        children: [
          Stack(
            children: [
              TextButton(
                  onPressed: widget.onPressChat,
                  child: Text(
                    widget.communityModel.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.lightSecondaryColor),
                  )),
              if (notificationsNum > 0)
                Positioned(
                  top: 2,
                  right: 2,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 6,
                    child: Text(
                      notificationsNum > 99 ? '+99' : '$notificationsNum',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 7, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 10.w,
          ),
          Visibility(
            visible: widget.communityModel.type != UserType.guest.name && !widget.isArchive,
            replacement: const SizedBox.shrink(),
            child: IconButton(
                onPressed: widget.onPressEdit, icon: const Icon(AppIcons.edit)),
          ),
          Visibility(
            visible: widget.communityModel.type == UserType.admin.name || widget.communityModel.type == null,
            child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: widget.onPressDelete,
            ),
          )
        ],
      ),
    );
  }
}
