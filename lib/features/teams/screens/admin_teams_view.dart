import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/teams/widgets/team_item.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_error_view.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AdminTeamsView extends StatefulWidget {
  const AdminTeamsView({Key? key}) : super(key: key);

  @override
  State<AdminTeamsView> createState() => _AdminTeamsViewState();
}

class _AdminTeamsViewState extends State<AdminTeamsView>
    with AutomaticKeepAliveClientMixin<AdminTeamsView> {
  TeamsCubit get cubit => context.read<TeamsCubit>();

  void _getInitialAdminTeams() {
    cubit.adminTeamsPagingController.addPageRequestListener((pageKey) {
      cubit.getAdminTeams(pageKey);
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitialAdminTeams();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async => cubit.adminTeamsPagingController.refresh(),
      color: AppColors.lightPrimaryColor,
      child: BlocBuilder<TeamsCubit, TeamsState>(
        buildWhen: (previous, current) =>
            current is DeleteTeamSuccess ||
            current is AddToArchiveSuccess ||
            current is DeleteCommunitySuccess ||
            current is DeleteSubCommunitySuccess,
        builder: (context, state) => PagedListView.separated(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 30.h, top: 15.h),
          separatorBuilder: (context, index) => SizedBox(
            height: 15.h,
          ),
          pagingController: cubit.adminTeamsPagingController,
          builderDelegate: PagedChildBuilderDelegate<TeamModel>(
            itemBuilder: (context, item, index) => Slidable(
              key: ObjectKey(item.id),
              startActionPane: ActionPane(
                  motion: const BehindMotion(),
                  extentRatio: .45,
                  children: [
                    SlidableAction(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      backgroundColor: AppColors.lightSecondaryColor,
                      autoClose: true,
                      onPressed: (context) {
                        AppFunctions.showAdaptiveDialog(
                          context,
                          title: LocaleKeys.do_you_want_archive_this_team.tr(),
                          actionName: LocaleKeys.archive.tr(),
                          onPress: () {
                            cubit.archiveChannel(item.id);
                          },
                        );
                      },
                      icon: Icons.archive,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    SlidableAction(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      backgroundColor: Colors.red,
                      autoClose: true,
                      onPressed: (context) {
                        AppFunctions.showAdaptiveDialog(
                          context,
                          title: LocaleKeys.do_you_want_delete_team.tr(),
                          actionName: LocaleKeys.delete.tr(),
                          onPress: () {
                            cubit.deleteTeam(item.id);
                          },
                        );
                      },
                      icon: AppIcons.delete,
                    ),
                    SizedBox(
                      width: 5.w,
                    )
                  ]),
              child: TeamItem(
                team: item,
                isAdmin: true,
              ),
            ),
            firstPageProgressIndicatorBuilder: (_) => const Center(child: MyProgress()),
            firstPageErrorIndicatorBuilder: (context) => TeamsErrorView(message: cubit.adminTeamsPagingController.error),
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: EmptyWidget(text: '', image: AppImages.emptyTeams),
            ),
            newPageProgressIndicatorBuilder: (_) => const Center(child: MyProgress()),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
