import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/teams/bloc/teams_cubit.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/teams/widgets/team_item.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_error_view.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ArchivedTeamsView extends StatefulWidget {
  const ArchivedTeamsView({Key? key}) : super(key: key);

  @override
  State<ArchivedTeamsView> createState() => _ArchivedTeamsViewState();
}

class _ArchivedTeamsViewState extends State<ArchivedTeamsView>
    with AutomaticKeepAliveClientMixin<ArchivedTeamsView> {
  TeamsCubit get cubit => context.read<TeamsCubit>();

  void _getInitialArchivedTeams() {
    cubit.archivedTeamsPagingController.addPageRequestListener((pageKey) {
      cubit.getArchivedTeams(pageKey);
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitialArchivedTeams();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async => cubit.archivedTeamsPagingController.refresh(),
      color: Theme.of(context).indicatorColor,
      child: BlocBuilder<TeamsCubit, TeamsState>(
        buildWhen: (previous, current) => current is DeleteArchiveSuccess,
        builder: (context, state) => PagedListView.separated(
          padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 30.h, top: 15.h),
          separatorBuilder: (context, index) => SizedBox(
            height: 15.h,
          ),
          pagingController: cubit.archivedTeamsPagingController,
          builderDelegate: PagedChildBuilderDelegate<TeamModel>(
              itemBuilder: (context, item, index) => item.type == UserType.admin.name
                  ? Slidable(
                      key: ObjectKey(item),
                      startActionPane: ActionPane(
                          motion: const BehindMotion(),
                          extentRatio: .25,
                          children: [
                            SlidableAction(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              backgroundColor: Colors.red,
                              autoClose: true,
                              onPressed: (context) {
                                AppFunctions.showAdaptiveDialog(
                                  context,
                                  title:
                                      LocaleKeys.do_you_want_delete_team.tr(),
                                  actionName: LocaleKeys.delete.tr(),
                                  onPress: () {
                                    cubit.deleteArchiveChannel(item.id);
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
                        isAdmin: false,
                        isArchive: true,
                      ),
                    )
                  : TeamItem(
                      team:
                          cubit.archivedTeamsPagingController.itemList![index],
                      isAdmin: false,
                      isArchive: true,
                    ),
              firstPageProgressIndicatorBuilder: (_) => const Center(
                    child: MyProgress(),
                  ),
              firstPageErrorIndicatorBuilder: (context) => TeamsErrorView(
                  message: cubit.archivedTeamsPagingController.error),
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
