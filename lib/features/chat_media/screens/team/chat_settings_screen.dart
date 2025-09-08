import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/team_chat_media_bloc/chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/team/chat_files_view.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/team/chat_links_view.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/team/chat_media_view.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/team/settings_view.dart';
import 'package:new_fly_easy_new/features/library/widgets/media_tab_bar.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({Key? key, required this.teamId,}) : super(key: key);
  final String teamId;

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen>
    with SingleTickerProviderStateMixin {
  ChatMediaCubit get cubit=>ChatMediaCubit.get(context);
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    ChatMediaCubit
        .get(context)
        .teamId = widget.teamId;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatMediaCubit,ChatMediaState>(
      listener: _blocListener,
      child: SizedBox(
        height: context.height * .9,
        child: Column(
          children: [
            SizedBox(height: 15.h,),
            MediaTabBar(tabController: _tabController, tabs:  [
              Text(LocaleKeys.settings.tr()),
              Text(LocaleKeys.media.tr()),
              Text(LocaleKeys.links.tr()),
              Text(LocaleKeys.files.tr())
            ]),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
                child: TabBarView(controller: _tabController, children: const [
                  SettingsView(),
                  ChatMediaView(),
                  ChatLinksView(),
                  ChatFilesView(),
                ]))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void _blocListener(BuildContext context,ChatMediaState state){
    if (state is SettingsErrorState) {
      AppFunctions.showToast(
          message: state.error, state: ToastStates.error);
    }else if(state is LeaveTeamSuccess){
      GlobalAppCubit.get(context).removeTeamAfterLeave(int.parse(widget.teamId));
      context.pop();context.pop();
    }
  }

}
