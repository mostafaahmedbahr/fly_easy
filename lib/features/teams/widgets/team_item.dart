import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';
import 'package:new_fly_easy_new/features/add_community/screens/add_community_bottom_sheet.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';
import 'package:new_fly_easy_new/features/teams/models/community_model.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/teams/widgets/communities_list.dart';
import 'package:new_fly_easy_new/features/teams/widgets/no_charge_dialog.dart';
import 'package:new_fly_easy_new/features/teams/widgets/team_floating_row_buttons.dart';
import 'package:new_fly_easy_new/features/teams/widgets/team_image.dart';
import 'package:new_fly_easy_new/features/teams/widgets/team_info_text.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class TeamItem extends StatefulWidget {
  const TeamItem({
    Key? key,
    required this.team,
    required this.isAdmin,
    this.isArchive = false,
  }) : super(key: key);
  final TeamModel team;
  final bool isAdmin;
  final bool isArchive;

  @override
  State<TeamItem> createState() => _TeamItemState();
}

class _TeamItemState extends State<TeamItem> {
  TeamsCubit get cubit => context.read<TeamsCubit>();

  ThemeData get themeData => Theme.of(context);

  int notificationsNum = 0;
  bool isOpened = false;
  double cardHeight = 110.h;
  double expandedHeight = 305.h;
  double unExpandedHeight = 110.h;
  List<CommunityModel> communities = [];

  @override
  void initState() {
    super.initState();
    notificationsNum = widget.team.notificationsCount;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlobalAppCubit, GlobalAppState>(
      listenWhen: _listenWhen,
      listener: _blocListener,
      buildWhen: _buildWhen,
      builder: (context, state) => Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: GestureDetector(
              onTap: _onTeamTaped,
              child: AnimatedContainer(
                height: cardHeight,
                padding: EdgeInsets.only(
                    left: 15.w, right: 15.w, top: 10.h, bottom: 15.h),
                decoration: ShapeDecoration(
                  color: themeData.cardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.09),
                      side: BorderSide(
                          color: notificationsNum > 0
                              ? AppColors.lightSecondaryColor
                              : Colors.transparent,
                          width: 1.5)),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 35.16,
                      offset: Offset(0, 20.09),
                      spreadRadius: 0,
                    )
                  ],
                ),
                duration: const Duration(milliseconds: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) => IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TeamImage(
                                imageUrl: widget.team.image,
                                teamId: widget.team.id.toString(),
                                width: constraints.maxWidth * .25,
                                notificationsNumber: notificationsNum),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                                child: TeamInfoText(
                                    team: widget.team,
                                    isOpened: isOpened,
                                    showEditBottomSheet: () =>
                                        _showAddChannelSheet(isEdit: true)))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: CommunitiesList(
                      communities: widget.team.communities,
                      teamId: widget.team.id,
                      isArchive: widget.isArchive,
                    ))
                  ],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            end: 0,
            child: TeamFloatingRowButtons(
                isAdmin: widget.isAdmin,
                teamModel: widget.team,
                onAddCommunityPressed: _onAddCommunityPressed,
                onChatPressed: _onChatPressed,
                onDuplicatePressed: _onDuplicatedPressed),
          ),
        ],
      ),
    );
  }

  /// //////////////////////////////////
  /// //////// Helper Methods /////////
  /// /////////////////////////////////

  void _showAddChannelSheet({required bool isEdit}) {
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
              parentId: widget.team.id,
              level: 2,
              isEdit: isEdit,
            )),
      ),
    );
  }

  void _goToChat(TeamChatInfoModel chatInfo) {
    // TeamsCubit.get(context).clearTeamNotifications(chatInfo.id);
    sl<AppRouter>()
        .navigatorKey
        .currentState!
        .pushNamed(Routes.chat, arguments: chatInfo);
    setState(() {
      notificationsNum = 0;
    });
  }

  void _onTeamTaped() {
    if (widget.team.communities.isNotEmpty) {
      if (isOpened) {
        setState(() {
          cardHeight = unExpandedHeight;
          communities = [];
          isOpened = false;
        });
      } else {
        setState(() {
          cardHeight = expandedHeight;
          communities = widget.team.communities;
          isOpened = true;
        });
      }
    }
  }

  void _onAddCommunityPressed() {
    if (HiveUtils.hasMoreCommunities()) {
      _showAddChannelSheet(isEdit: false);
    } else {
      showDialog(
        context: context,
        builder: (context) => NoChargeDialog(
            message: LocaleKeys.you_consumed_all_communities.tr()),
      );
    }
  }

  void _onDuplicatedPressed() {
    if (HiveUtils.hasMoreCommunities()) {
      AppFunctions.showAdaptiveDialog(
        context,
        title: LocaleKeys.do_you_want_duplicate_team.tr(),
        actionName: LocaleKeys.yes.tr(),
        onPress: () {
          cubit.duplicateChannel(widget.team.id);
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            NoChargeDialog(message: LocaleKeys.you_consumed_all_teams.tr()),
      );
    }
  }

  void _onChatPressed() {
    _goToChat(TeamChatInfoModel(
        isTeam: true,
        id: widget.team.id,
        name: widget.team.name,
        image: widget.team.image));
  }

  void _blocListener(BuildContext context, GlobalAppState state) {
    if (state is ReceiveTeamNotification &&
        state.teamId.toString() == widget.team.id.toString()) {
      notificationsNum++;
    } else if (state is ClearTeamChatNotifications &&
        state.teamId.toString() == widget.team.id.toString()) {
      notificationsNum = 0;
    }
  }

  bool _listenWhen(previous, current) => (current is ReceiveTeamNotification &&
          current.teamId.toString() == widget.team.id.toString() ||
      current is ClearTeamChatNotifications);

  bool _buildWhen(previous, current) =>
      (current is ReceiveTeamNotification &&
          current.teamId.toString() == widget.team.id.toString()) ||
      (current is ClearTeamChatNotifications &&
          current.teamId.toString() == widget.team.id.toString());
}
