import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/widgets/custom_network_image.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';
import 'package:new_fly_easy_new/features/add_community/screens/add_community_bottom_sheet.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';
import 'package:new_fly_easy_new/features/teams/models/community_model.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/teams/widgets/no_access_dialog.dart';
import 'package:new_fly_easy_new/features/teams/widgets/no_charge_dialog.dart';
import 'package:new_fly_easy_new/features/teams/widgets/sub_communities_list.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class CommunityWidget extends StatefulWidget {
  const CommunityWidget({
    Key? key,
    required this.community,
    required this.teamId,
    this.isArchive = false,
  }) : super(key: key);
  final CommunityModel community;
  final int teamId;
  final bool isArchive;

  @override
  State<CommunityWidget> createState() => _CommunityWidgetState();
}

class _CommunityWidgetState extends State<CommunityWidget> {
  TeamsCubit get cubit => context.read<TeamsCubit>();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        tilePadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: Border.all(style: BorderStyle.none, color: Colors.transparent),
        expandedAlignment: Alignment.centerLeft,
        leading:
            CustomNetworkImage(width: 25.w, imageUrl: widget.community.image),
        iconColor: CacheUtils.isDarkMode()
            ? AppColors.lightSecondaryColor
            : Colors.black,
        collapsedIconColor: CacheUtils.isDarkMode()
            ? AppColors.lightSecondaryColor
            : Colors.black,
        title: Row(
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                if (widget.community.isJoined == true) {
                  _goToChat(TeamChatInfoModel(
                      id: widget.community.id,
                      name: widget.community.name,
                      image: widget.community.image,
                      isTeam: true));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => const NoAccessDialog(),
                  );
                }
              },
              child: Text(
                widget.community.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )),
            Visibility(
              visible: (_isModerator() && !widget.isArchive),
              replacement: const SizedBox.shrink(),
              child: _CustomIconButton(
                  icon: Icons.add,
                  onPress: () {
                    if (HiveUtils.hasMoreSubCommunities()) {
                      _showAddChannelSheet(isEdit: false);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => NoChargeDialog(
                            message: LocaleKeys.you_consumed_all_sub_communities
                                .tr()),
                      );
                    }
                  }),
            ),
            Visibility(
              visible: (_isModerator() && !widget.isArchive),
              replacement: const SizedBox.shrink(),
              child: _CustomIconButton(
                  icon: AppIcons.edit,
                  onPress: () {
                    _showAddChannelSheet(isEdit: true);
                  }),
            ),
            Visibility(
                visible: _isAdmin(),
                replacement: const SizedBox.shrink(),
                child: _CustomIconButton(
                  icon: Icons.delete,
                  onPress: () {
                    AppFunctions.showAdaptiveDialog(
                      context,
                      title: LocaleKeys.do_you_want_delete_community.tr(),
                      actionName: LocaleKeys.delete.tr(),
                      onPress: () {
                        cubit.deleteCommunity(
                            widget.community.id, widget.teamId);
                      },
                    );
                  },
                ))
          ],
        ),
        children: [
          SubCommunitiesList(
              teamId: widget.teamId,
              communityId: widget.community.id,
              subCommunities: widget.community.subChannels)
        ]);
  }

  /// ///////////// Helper Methods ///////////////////
  /// //////////////////////////////////////////////

  void _showAddChannelSheet({required bool isEdit, int? parentId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r))),
      builder: (context) => FractionallySizedBox(
        heightFactor: .9,
        child: BlocProvider(
            create: (context) => AddChannelCubit(),
            child: AddCommunitySheet(
              parentId: parentId ?? widget.community.id,
              level: 3,
              isEdit: isEdit,
            )),
      ),
    );
  }

  void _goToChat(TeamChatInfoModel chatInfo) {
    sl<AppRouter>()
        .navigatorKey
        .currentState!
        .pushNamed(Routes.chat, arguments: chatInfo);
  }

  bool _isModerator() => widget.community.type != UserType.guest.name;

  bool _isAdmin() => (widget.community.type == UserType.admin.name ||
      widget.community.type == null);
}

class _CustomIconButton extends StatelessWidget {
  const _CustomIconButton({Key? key, required this.icon, required this.onPress})
      : super(key: key);
  final IconData icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        enableFeedback: true,
        padding: EdgeInsets.zero,
        alignment: AlignmentDirectional.centerEnd,
        style: const ButtonStyle(
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
        ),
        onPressed: onPress,
        icon: Icon(icon, color: Theme.of(context).iconTheme.color));
  }
}
