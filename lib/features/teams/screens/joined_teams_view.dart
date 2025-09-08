import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/teams/widgets/team_item.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_error_view.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class JoinedTeamsView extends StatefulWidget {
  const JoinedTeamsView({
    Key? key,
  }) : super(key: key);

  @override
  State<JoinedTeamsView> createState() => _JoinedTeamsViewState();
}

class _JoinedTeamsViewState extends State<JoinedTeamsView> with AutomaticKeepAliveClientMixin<JoinedTeamsView> {
  TeamsCubit get cubit => context.read<TeamsCubit>();

  void _getInitialJoinedTeams() {
    cubit.joinedTeamsPagingController.addPageRequestListener((pageKey) {
      cubit.getJoinedTeams(pageKey);
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitialJoinedTeams();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<GlobalAppCubit, GlobalAppState>(
      listenWhen: (previous, current) => current is RemoveTeamAfterLeave,
      listener: (context, state) {
        if (state is RemoveTeamAfterLeave) {
          // widget.joinedTeamsPagingController.itemList!.removeWhere((element) => element.id==state.teamId);
          cubit.joinedTeamsPagingController.refresh();
          AppFunctions.showToast(
              message: LocaleKeys.you_left_the_team.tr(),
              state: ToastStates.error);
        }
      },
      buildWhen: (previous, current) => current is RemoveTeamAfterLeave,
      builder: (context, state) => RefreshIndicator(
        onRefresh: () async => cubit.joinedTeamsPagingController.refresh(),
        color: AppColors.lightPrimaryColor,
        child: PagedListView.separated(
          padding:
              EdgeInsets.only(left: 15.w, right: 15.w, bottom: 30.h, top: 15.h),
          separatorBuilder: (context, index) => SizedBox(
            height: 15.h,
          ),
          pagingController: cubit.joinedTeamsPagingController,
          builderDelegate: PagedChildBuilderDelegate<TeamModel>(
              itemBuilder: (context, item, index) => TeamItem(
                key: ObjectKey(item),
                    team: item,
                    isAdmin: false,
                  ),
              firstPageProgressIndicatorBuilder: (_) =>
                  const Center(child: MyProgress()),
              firstPageErrorIndicatorBuilder: (context) => TeamsErrorView(
                  message: cubit.joinedTeamsPagingController.error),
              noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: EmptyWidget(text: '', image: AppImages.emptyTeams),
                    // EmptyWidget(text: 'You have not any notifications'),
                  ),
              newPageProgressIndicatorBuilder: (_) =>
                  const Center(child: MyProgress())),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
