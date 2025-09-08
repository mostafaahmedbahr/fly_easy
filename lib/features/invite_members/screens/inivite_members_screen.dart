import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/add_community/models/invite_indentifier.dart';
import 'package:new_fly_easy_new/features/invite_members/bloc/invite_members_cubit.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/members_list.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/search_member_widget.dart';
import 'package:new_fly_easy_new/features/teams/widgets/no_charge_dialog.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class InviteMembersScreen extends StatefulWidget {
  const InviteMembersScreen({Key? key, required this.inviteIdentifier})
      : super(key: key);
  final InviteIdentifier inviteIdentifier;

  @override
  State<InviteMembersScreen> createState() => _InviteMembersScreenState();
}

class _InviteMembersScreenState extends State<InviteMembersScreen> {
  ThemeData get theme => Theme.of(context);
  InviteMembersCubit get cubit => InviteMembersCubit.get(context);
  final PagingController<int, MemberModel> _membersPagingController = PagingController<int, MemberModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);

  @override
  void initState() {
    super.initState();
    _getInitialMembers();
    if (widget.inviteIdentifier.isModeratorSelection) {
      cubit.selectedMembers =
          widget.inviteIdentifier.addChannelCubit.moderators;
    } else {
      cubit.selectedMembers = widget.inviteIdentifier.addChannelCubit.guests;
    }
  }

  @override
  void dispose() {
    _membersPagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          SearchMemberWidget(onSearch: (value) {
            cubit.searchKey = value;
            _membersPagingController.refresh();
          },),
          SizedBox(
            height: 15.h,
          ),
          Expanded(
            child: MembersList(membersPagingController: _membersPagingController),
          )
        ],
      ),
    );
  }

  /// //////////////////////////////////////////////
  /// ////////// Helper Widgets /////////////////////
  /// //////////////////////////////////////////////

  AppBar _appBar() => AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(LocaleKeys.invite_members.tr()),
        actions: [
          TextButton(
              onPressed: _inviteMembers,
              child: Text(
                // LocaleKeys.invite.tr(),
                LocaleKeys.save.tr(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.roboto),
              ))
        ],
      );

  /// ////////////////////////////////////////////
  /// ////////////// Helper Methods ////////////////
  /// /////////////////////////////////////////////

  void _getInitialMembers() {
    _membersPagingController.addPageRequestListener((pageKey) {
      cubit.getMembers(
        pageKey: pageKey,
        pagingController: _membersPagingController,
      );
    });
  }

  bool _checkMembersCharge() {
    return (cubit.selectedMembers.length <=
        HiveUtils.getUserData()!.remainsMembersCount);
  }

  void _inviteMembers() {
    if (_checkMembersCharge()) {
      if (widget.inviteIdentifier.isModeratorSelection) {
        widget.inviteIdentifier.addChannelCubit
            .addModerators(cubit.selectedMembers);
      } else {
        widget.inviteIdentifier.addChannelCubit
            .addGuests(cubit.selectedMembers);
      }
      context.pop();
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            NoChargeDialog(
                message:
                LocaleKeys.you_consumed_all_members.tr()),
      );
      sl<AppRouter>().navigatorKey.currentState!.pushNamed(Routes.plans);
    }
  }
}
