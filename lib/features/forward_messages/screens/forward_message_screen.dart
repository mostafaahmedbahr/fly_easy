import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/features/forward_messages/bloc/forward_message_cubit.dart';
import 'package:new_fly_easy_new/features/forward_messages/models/forward_info_model.dart';
import 'package:new_fly_easy_new/features/forward_messages/widgets/forward_members_view.dart';
import 'package:new_fly_easy_new/features/forward_messages/widgets/forward_teams_view.dart';
import 'package:new_fly_easy_new/features/widgets/tab_bar.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ForwardMessageScreen extends StatefulWidget {
  const ForwardMessageScreen({Key? key, required this.info,required this.isExternalShare}) : super(key: key);
  final ForwardInfoModel info;
  final bool isExternalShare;

  @override
  State<ForwardMessageScreen> createState() => _ForwardMessageScreenState();
}

class _ForwardMessageScreenState extends State<ForwardMessageScreen>
    with SingleTickerProviderStateMixin {
  ForwardMessageCubit get cubit => ForwardMessageCubit.get(context);
  late TabController _tabController;

  // final PagingController<int, MemberModel> _membersPagingController =
  //     PagingController<int, MemberModel>(
  //         firstPageKey: 1, invisibleItemsThreshold: 1);
  // final PagingController<int, ChannelModel> _teamsPagingController =
  //     PagingController<int, ChannelModel>(
  //         firstPageKey: 1, invisibleItemsThreshold: 1);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    cubit.currentUserId = widget.info.userId;
    cubit.currentTeamId = widget.info.teamId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForwardMessageCubit, ForwardMessageState>(
      listenWhen: (previous, current) => current is ErrorState,
      listener: (context, state) {
        if (state is ErrorState) {
          AppFunctions.showToast(
              message: state.error, state: ToastStates.error);
        }
      },
      child: Scaffold(
        appBar: _appBar(),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              TabBarWidget(tabController: _tabController, tabs: [
                Tab(child: Text(LocaleKeys.members.tr())),
                Tab(child: Text(LocaleKeys.teams.tr())),

              ]),
              Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: const [
                    // ForwardTeamsView(teamsPagingController: _teamsPagingController),
                    // ForwardUsersView(membersPagingController: _membersPagingController,),
                        ForwardUsersViewWithoutPagination(),
                    ForwardTeamsViewWithoutPagination(),

                  ]))
            ],
          ),
        ),
        floatingActionButton:
            BlocBuilder<ForwardMessageCubit, ForwardMessageState>(
          buildWhen: (previous, current) =>
              current is SelectTeam ||
              current is SelectMember ||
              current is SelectAllMembers ||
              current is SelectAllTeams ||
              current is UnSelectMember ||
              current is UnSelectTeam,
          builder: (context, state) => (cubit.selectedMembers.isNotEmpty ||
                  cubit.selectedTeams.isNotEmpty)
              ? FloatingActionButton(
                  backgroundColor: AppColors.lightPrimaryColor,
                  onPressed: _forwardMessage,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text(
          widget.isExternalShare? 'Share To...':
          LocaleKeys.forward_message_to.tr(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      );

  void _forwardMessage() {
    if(widget.isExternalShare){
      cubit.sendMessageToTeams(widget.info.messages);
      cubit.sendMessageToUsers(widget.info.messages);
    }else{
      cubit.forwardMessageToMembers(widget.info.messages);
      cubit.forwardMessageToTeams(widget.info.messages);
    }
    AppFunctions.showToast(
        message: LocaleKeys.sending_message.tr(), state: ToastStates.error);
    context.pop();
  }

// @override
// void dispose() {
//   super.dispose();
//   _membersPagingController.dispose();
//   _teamsPagingController.dispose();
// }
}
