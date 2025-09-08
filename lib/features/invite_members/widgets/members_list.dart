import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/invite_members/bloc/invite_members_cubit.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/member_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MembersList extends StatelessWidget {
  const MembersList({Key? key,required this.membersPagingController}) : super(key: key);
final PagingController<int,MemberModel>membersPagingController;
  @override
  Widget build(BuildContext context) {
    InviteMembersCubit cubit = InviteMembersCubit.get(context);
    return PagedListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      separatorBuilder: (context, index) => _customDivider(),
      pagingController: membersPagingController,
      builderDelegate: PagedChildBuilderDelegate<MemberModel>(
          itemBuilder: (context, item, index) => MemberWidget(
            member: item,
            isSelected: cubit.selectedMembers.contains(item),
          ),
          firstPageProgressIndicatorBuilder: (_) =>
          const Center(child: MyProgress()),
          firstPageErrorIndicatorBuilder: (context) {
            return Center(
                child: Text('${membersPagingController.error}'));
          },
          noItemsFoundIndicatorBuilder: (context) => const Center(
            child: SizedBox.shrink(),
            // EmptyWidget(text: 'You have not any notifications'),
          ),
          newPageProgressIndicatorBuilder: (_) =>
          const Center(child: MyProgress())
      ),
    );
  }

  Widget _customDivider() => Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: const Divider(color: Color(0xffE0E0E0)));

}
