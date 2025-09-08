import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/forward_messages/bloc/forward_message_cubit.dart';
import 'package:new_fly_easy_new/features/forward_messages/widgets/forward_member_widget.dart';
import 'package:new_fly_easy_new/features/forward_messages/widgets/forward_members_list.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/search_field.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ForwardUsersView extends StatefulWidget {
  const ForwardUsersView({Key? key, required this.membersPagingController})
      : super(key: key);
  final PagingController<int, MemberModel> membersPagingController;

  @override
  State<ForwardUsersView> createState() => _ForwardUsersViewState();
}

class _ForwardUsersViewState extends State<ForwardUsersView>
    with AutomaticKeepAliveClientMixin<ForwardUsersView> {
  ForwardMessageCubit get cubit => ForwardMessageCubit.get(context);

  void _getInitialMembers() {
    widget.membersPagingController.addPageRequestListener((pageKey) {
      cubit.getAvailableUsersPaginated(widget.membersPagingController, pageKey);
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitialMembers();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async => widget.membersPagingController.refresh(),
      color: AppColors.lightPrimaryColor,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: SearchField(
                  onChange: (value) {
                    cubit.usersSearchKey = value;
                    widget.membersPagingController.refresh();
                  },
                  hint: LocaleKeys.search_by.tr())),
          Expanded(
            child: PagedListView.separated(
              padding: EdgeInsets.only(
                  left: 15.w, right: 15.w, bottom: 30.h, top: 10.h),
              separatorBuilder: (context, index) => SizedBox(
                height: 15.h,
              ),
              pagingController: widget.membersPagingController,
              builderDelegate: PagedChildBuilderDelegate<MemberModel>(
                  itemBuilder: (context, item, index) =>
                      ForwardMemberWidget(member: item),
                  firstPageProgressIndicatorBuilder: (_) =>
                      const Center(child: MyProgress()),
                  firstPageErrorIndicatorBuilder: (context) {
                    return Center(
                        child: Text('${widget.membersPagingController.error}'));
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

class ForwardUsersViewWithoutPagination extends StatefulWidget {
  const ForwardUsersViewWithoutPagination({Key? key}) : super(key: key);

  @override
  State<ForwardUsersViewWithoutPagination> createState() =>
      _ForwardUsersViewWithoutPaginationState();
}

class _ForwardUsersViewWithoutPaginationState
    extends State<ForwardUsersViewWithoutPagination>
    with AutomaticKeepAliveClientMixin<ForwardUsersViewWithoutPagination> {
  ForwardMessageCubit get cubit => ForwardMessageCubit.get(context);
  bool allMembersSelected = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => cubit.getAvailableMembers());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: () async => cubit.getAvailableMembers(),
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
                    cubit.usersSearchKey = value;
                    cubit.getAvailableMembers();
                  },
                  hint: LocaleKeys.search_by.tr())),
          BlocConsumer<ForwardMessageCubit, ForwardMessageState>(
            listenWhen: (previous, current) =>
                current is SelectMember ||current is UnSelectMember ||current is SelectAllMembers,
            listener: (context, state) {
              if (state is SelectAllMembers) {
                allMembersSelected = state.selected;
              } else if (state is UnSelectMember) {
                allMembersSelected = false;
              }else if(state is SelectMember){
                if (cubit.selectedMembers.length == cubit.members.length) {
                  allMembersSelected = true;
                }
              }
            },
            buildWhen: (previous, current) =>
                current is SelectMember || current is UnSelectMember||current is SelectAllMembers,
            builder: (context, state) => CheckboxListTile(
                value: allMembersSelected,
                enableFeedback: true,
                checkColor: AppColors.lightPrimaryColor,
                side: BorderSide(color: Theme.of(context).iconTheme.color!),
                onChanged: (value) {
                  setState(() {
                    allMembersSelected = value!;
                    if (cubit.allMembersSelected) {
                      cubit.unSelectAllMembers();
                    } else {
                      cubit.selectAllMembers();
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
          const ForwardMembersList(),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
