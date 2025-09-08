import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget(
      {Key? key,
      required this.tabController,
      required this.tabs,
      this.isScrollable})
      : super(key: key);
  final TabController tabController;
  final List<Tab> tabs;
  final bool? isScrollable;

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: tabController,
        tabAlignment:isScrollable!=null? TabAlignment.start:null,
        indicator: UnderlineTabIndicator(
          insets: const EdgeInsets.all(0),
          borderSide: BorderSide(
            color: Theme.of(context).indicatorColor,
            width: 1.5,
          ),
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        indicatorPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: isScrollable ?? false,
        unselectedLabelColor: Theme.of(context).disabledColor,
        unselectedLabelStyle: TextStyle(
          color: Theme.of(context).disabledColor,
          fontWeight: FontWeight.w500,
        ),
        labelColor: Theme.of(context).indicatorColor,
        labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontFamily: AppFonts.roboto,
            color: Theme.of(context).indicatorColor,
            fontSize: 16.sp),
        enableFeedback: false,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        dividerColor: Colors.transparent,
        indicatorColor: Theme.of(context).indicatorColor,
        padding: EdgeInsets.zero,
        tabs: tabs);
  }
}
