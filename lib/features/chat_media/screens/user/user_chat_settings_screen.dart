import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/user_chat_media_bloc/user_chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/user/user_files_view.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/user/user_links_view.dart';
import 'package:new_fly_easy_new/features/chat_media/screens/user/user_media_view.dart';
import 'package:new_fly_easy_new/features/library/widgets/media_tab_bar.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class UserChatSettingsScreen extends StatefulWidget {
  const UserChatSettingsScreen({Key? key, required this.userId})
      : super(key: key);
  final int userId;

  @override
  State<UserChatSettingsScreen> createState() => _UserChatSettingsScreenState();
}

class _UserChatSettingsScreenState extends State<UserChatSettingsScreen>
    with SingleTickerProviderStateMixin {
  UserChatMediaCubit get cubit => UserChatMediaCubit.get(context);
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    UserChatMediaCubit.get(context).userId = widget.userId;

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height * .9,
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          MediaTabBar(tabController: _tabController, tabs: [
            Text(LocaleKeys.media.tr()),
            Text(LocaleKeys.links.tr()),
            Text(LocaleKeys.files.tr())
          ]),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
              child: TabBarView(controller: _tabController, children: const [
            UserChatMediaView(),
            UserChatLinksView(),
            UserChatFilesView(),
          ]))
        ],
      ),
    );
  }
}
