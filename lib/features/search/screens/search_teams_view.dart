import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/search_field.dart';
import 'package:new_fly_easy_new/features/search/bloc/search_cubit.dart';
import 'package:new_fly_easy_new/features/search/widgets/search_team_widget.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchTeamView extends StatefulWidget {
  const SearchTeamView({Key? key,required this.teamsPagingController}) : super(key: key);
  final PagingController<int, TeamModel> teamsPagingController;

  @override
  State<SearchTeamView> createState() => _SearchTeamViewState();
}

class _SearchTeamViewState extends State<SearchTeamView>
    with AutomaticKeepAliveClientMixin<SearchTeamView> {
  SearchCubit get cubit => SearchCubit.get(context);

  void _getInitialTeams() {
    widget.teamsPagingController.addPageRequestListener((pageKey) {
      cubit.getMyTeams(widget.teamsPagingController, pageKey);
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
                      SearchTeamWidget(team: item),
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
