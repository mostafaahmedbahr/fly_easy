import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';
import 'package:new_fly_easy_new/features/add_community/screens/add_community_bottom_sheet.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';
import 'package:new_fly_easy_new/features/teams/models/community_model.dart';
import 'package:new_fly_easy_new/features/teams/widgets/sub_community_item.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class SubCommunitiesList extends StatelessWidget {
  const SubCommunitiesList(
      {super.key,
      required this.teamId,
      required this.communityId,
      required this.subCommunities,
      this.isArchive = false});

  final int teamId;
  final int communityId;
  final List<CommunityModel> subCommunities;
  final bool isArchive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: subCommunities
          .map((subCommunity) => SubCommunityItem(
                onPressEdit: () {
                  _showAddChannelSheet(context,
                      isEdit: true, parentId: subCommunity.id);
                },
                onPressChat: () {
                  _goToChat(TeamChatInfoModel(
                    id: subCommunity.id,
                    name: subCommunity.name,
                    image: subCommunity.image,
                    isTeam: true,
                  ));
                },
                onPressDelete: () {
                  AppFunctions.showAdaptiveDialog(
                    context,
                    title: LocaleKeys.do_you_want_delete_sub_community.tr(),
                    actionName: LocaleKeys.delete.tr(),
                    onPress: () {
                      context.read<TeamsCubit>().deleteSubCommunitySuccess(
                          teamId, communityId, subCommunity.id);
                    },
                  );
                },
                communityModel: subCommunity,
                isArchive: isArchive,
              ))
          .toList(),
    );
  }

  void _goToChat(TeamChatInfoModel chatInfo) {
    sl<AppRouter>()
        .navigatorKey
        .currentState!
        .pushNamed(Routes.chat, arguments: chatInfo);
  }

  void _showAddChannelSheet(BuildContext context,
      {required bool isEdit, int? parentId}) {
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
              parentId: parentId ?? communityId,
              level: 3,
              isEdit: isEdit,
            )),
      ),
    );
  }
}
