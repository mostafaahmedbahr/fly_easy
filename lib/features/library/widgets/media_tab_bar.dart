import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

class MediaTabBar extends StatelessWidget {
  const MediaTabBar({Key? key, required this.tabController, required this.tabs})
      : super(key: key);
  final TabController tabController;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorPadding: EdgeInsets.zero,
        controller: tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        indicator: BoxDecoration(
          color: Theme.of(context).tabBarTheme.indicatorColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: Theme.of(context).indicatorColor,
        unselectedLabelStyle: TextStyle(
          fontSize: 16.sp,
          color: Theme.of(context).indicatorColor,
          fontWeight: FontWeight.w600,
        ),
        labelColor: Theme.of(context).indicatorColor,
        labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
            fontFamily: AppFonts.roboto,
            color: Theme.of(context).indicatorColor,
            fontSize: 16.sp),
        enableFeedback: false,
        dividerColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        // indicatorColor: Theme.of(context).indicatorColor,
        padding: EdgeInsets.zero,
        tabs: tabs.map((e) => Tab(child: e)).toList());
  }
}
