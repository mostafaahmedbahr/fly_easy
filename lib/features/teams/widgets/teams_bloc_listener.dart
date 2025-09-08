import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/widgets/dialog_progress_indicator.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class TeamsBlocListener extends StatelessWidget {
  const TeamsBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamsCubit, TeamsState>(
      listener: (context, state) {
        if (state is ErrorState) {
          AppFunctions.showToast(
              message: state.error, state: ToastStates.error);
        } else if (state is DeleteTeamSuccess) {
          context
              .read<TeamsCubit>()
              .adminTeamsPagingController
              .itemList!
              .removeWhere((element) => element.id == state.channelId);
          Navigator.of(context, rootNavigator: true).pop();
        } else if (state is DeleteCommunitySuccess) {
          context
              .read<TeamsCubit>()
              .adminTeamsPagingController
              .itemList!
              .firstWhere((element) => element.id == state.teamId)
              .communities
              .removeWhere((element) => element.id == state.communityId);
          Navigator.of(context, rootNavigator: true).pop();
        } else if (state is DeleteSubCommunitySuccess) {
          context
              .read<TeamsCubit>()
              .adminTeamsPagingController
              .itemList!
              .firstWhere((element) => element.id == state.teamId)
              .communities
              .firstWhere((element) => element.id == state.communityId)
              .subChannels
              .removeWhere((element) => element.id == state.subCommunityId);
          Navigator.of(context, rootNavigator: true).pop();
        } else if (state is DeleteArchiveSuccess) {
          context
              .read<TeamsCubit>()
              .archivedTeamsPagingController
              .itemList!
              .removeWhere((element) => element.id == state.channelId);
          Navigator.of(context, rootNavigator: true).pop();
        } else if (state is AddToArchiveSuccess) {
          context
              .read<TeamsCubit>()
              .adminTeamsPagingController
              .itemList!
              .removeWhere((element) => element.id == state.channelId);
          context.read<TeamsCubit>().archivedTeamsPagingController.refresh();
          Navigator.of(context, rootNavigator: true).pop();
          AppFunctions.showToast(
              message: LocaleKeys.the_team_added_to_archive.tr(),
              state: ToastStates.success);
        } else if (state is DuplicateChannelSuccess) {
          context.read<TeamsCubit>().adminTeamsPagingController.refresh();
          Navigator.of(context, rootNavigator: true).pop();
          AppFunctions.showToast(
              message: LocaleKeys.the_team_duplicated_success.tr(),
              state: ToastStates.success);
        } else if (state is DeleteTeamLoad ||
            state is AddToArchiveLoad ||
            state is DuplicateChannelLoad ||
            state is DeleteArchiveLoad) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const DialogIndicator(),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
