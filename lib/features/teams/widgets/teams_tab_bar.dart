import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/show_case_widget.dart';
import 'package:new_fly_easy_new/features/widgets/tab_bar.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class TeamsTabBar extends StatelessWidget {
  const TeamsTabBar({super.key, required this.tabController,required this.archiveHintKey});

  final TabController tabController;
  final GlobalKey? archiveHintKey;

  @override
  Widget build(BuildContext context) {
    return TabBarWidget(
        tabController: tabController,
        isScrollable: true,
        tabs: [
          Tab(
              child: Text(
            LocaleKeys.your_teams.tr(),
          )),
          Tab(
              child: Text(
            LocaleKeys.joined_teams.tr(),
          )),
          Tab(
            child: CustomShowCase(
                description: AppStrings.archivedTeamsHint,
                caseKey: archiveHintKey,
                child: Text(LocaleKeys.archive.tr())),
          )
        ]);
  }
}
