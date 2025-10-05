import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/search_field.dart';
import 'package:new_fly_easy_new/features/search/bloc/search_cubit.dart';
import 'package:new_fly_easy_new/features/search/widgets/search_member_widget.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchMembersView extends StatefulWidget {
  const SearchMembersView({super.key, required this.membersPagingController});
  final PagingController<int, MemberModel> membersPagingController;

  @override
  State<SearchMembersView> createState() => _SearchMembersViewState();
}

class _SearchMembersViewState extends State<SearchMembersView>
    with AutomaticKeepAliveClientMixin<SearchMembersView> {
  SearchCubit get cubit => SearchCubit.get(context);

  void _getInitialMembers() {
    widget.membersPagingController.addPageRequestListener((pageKey) {
      cubit.getAvailableUsers(widget.membersPagingController, pageKey);
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
                    print(value);
                    print("wwwwwww");
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
                  itemBuilder: (context, item, index) => SearchMemberWidget(
                        member: item,
                        index: index,
                      ),
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
                  newPageProgressIndicatorBuilder: (_) => const Center(child: MyProgress())),
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
