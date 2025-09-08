import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/forward_messages/bloc/forward_message_cubit.dart';
import 'package:new_fly_easy_new/features/forward_messages/widgets/forward_team_widget.dart';
import 'package:new_fly_easy_new/features/forward_messages/widgets/forward_teams_list.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/search_field.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ForwardTeamsView extends StatefulWidget {
  const ForwardTeamsView({Key? key, required this.teamsPagingController})
      : super(key: key);
  final PagingController<int, TeamModel> teamsPagingController;

  @override
  State<ForwardTeamsView> createState() => _ForwardTeamsViewState();
}

class _ForwardTeamsViewState extends State<ForwardTeamsView>
    with AutomaticKeepAliveClientMixin<ForwardTeamsView> {
  ForwardMessageCubit get cubit => ForwardMessageCubit.get(context);

  void _getInitialTeams() {
    widget.teamsPagingController.addPageRequestListener((pageKey) {
      cubit.getAvailableTeamsPaginated(widget.teamsPagingController, pageKey);
    });
  }

  @override
  void initState() {
    _getInitialTeams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async => widget.teamsPagingController.refresh(),
      color: AppColors.lightPrimaryColor,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: SearchField(
                  onChange: (value) {
                    cubit.teamsSearchKey = value;
                    widget.teamsPagingController.refresh();
                  },
                  hint: LocaleKeys.search_for_teams.tr())),
          Expanded(
            child: PagedListView.separated(
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
                bottom: 30.h,
              ),
              separatorBuilder: (context, index) => SizedBox(
                height: 15.h,
              ),
              pagingController: widget.teamsPagingController,
              builderDelegate: PagedChildBuilderDelegate<TeamModel>(
                  itemBuilder: (context, item, index) =>
                      ForwardTeamWidget(team: item),
                  firstPageProgressIndicatorBuilder: (_) =>
                      const Center(child: MyProgress()),
                  firstPageErrorIndicatorBuilder: (context) {
                    return Center(
                        child: Text('${widget.teamsPagingController.error}'));
                  },
                  noItemsFoundIndicatorBuilder: (context) => const Center(
                        child:
                            EmptyWidget(text: '', image: AppImages.emptyTeams),
                        // EmptyWidget(text: 'You have not any notifications'),
                      ),
                  newPageProgressIndicatorBuilder: (_) =>
                      const Center(child: MyProgress())),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/// //////////////////////////////////////////////////////////////////////////////////
/// ////////////////// New Code without pagination to solve select all problem ///////
/// //////////////////////////////////////////////////////////////////////////////////

class ForwardTeamsViewWithoutPagination extends StatefulWidget {
  const ForwardTeamsViewWithoutPagination({Key? key}) : super(key: key);

  @override
  State<ForwardTeamsViewWithoutPagination> createState() =>
      _ForwardTeamsViewWithoutPaginationState();
}

class _ForwardTeamsViewWithoutPaginationState
    extends State<ForwardTeamsViewWithoutPagination>
    with AutomaticKeepAliveClientMixin<ForwardTeamsViewWithoutPagination> {
  ForwardMessageCubit get cubit => ForwardMessageCubit.get(context);
  bool allTeamsSelected = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => cubit.getAvailableTeams());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: () async => cubit.getAvailableTeams(),
      color: AppColors.lightPrimaryColor,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
                top: 15.h,
                bottom: 5.h,
              ),
              child: SearchField(
                  onChange: (value) {
                    cubit.teamsSearchKey = value;
                    cubit.getAvailableTeams();
                  },
                  hint: LocaleKeys.search_for_teams.tr())),
          BlocConsumer<ForwardMessageCubit, ForwardMessageState>(
            listenWhen: (previous, current) =>
                current is SelectTeam ||
                current is UnSelectTeam ||
                current is SelectAllTeams,
            listener: (context, state) {
              if (state is SelectAllTeams) {
                allTeamsSelected = state.selected;
              } else if (state is UnSelectTeam) {
                allTeamsSelected = false;
              } else if (state is SelectTeam) {
                if (cubit.selectedTeams.length == cubit.myTeams.length) {
                  allTeamsSelected = true;
                }
              }
            },
            buildWhen: (previous, current) =>
                current is SelectTeam ||
                current is UnSelectTeam ||
                current is SelectAllTeams,
            builder: (context, state) => CheckboxListTile(
                value: allTeamsSelected,
                enableFeedback: true,
                checkColor: AppColors.lightPrimaryColor,
                side: BorderSide(color: Theme.of(context).iconTheme.color!),
                onChanged: (value) {
                  setState(() {
                    allTeamsSelected = value!;
                    if (cubit.allTeamsSelected) {
                      cubit.unSelectAllTeams();
                    } else {
                      cubit.selectAllTeams();
                    }
                  });
                },
                title: Text(
                  LocaleKeys.select_all.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 14.sp),
                )),
          ),
          SizedBox(
            height: 10.h,
          ),
          const ForwardTeamsList(),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
