import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/library/bloc/library_bloc/library_cubit.dart';
import 'package:new_fly_easy_new/features/library/models/section_model.dart';
import 'package:new_fly_easy_new/features/library/widgets/section_item.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_error_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SectionsView extends StatefulWidget {
  const SectionsView({
    Key? key,
  }) : super(key: key);

  @override
  State<SectionsView> createState() => _SectionsViewState();
}

class _SectionsViewState extends State<SectionsView> {
  LibraryCubit get cubit => LibraryCubit.get(context);
  final PagingController<int, SectionModel> _sectionPagingController =
      PagingController<int, SectionModel>(
          firstPageKey: 1, invisibleItemsThreshold: 1);

  void _getSections() async {
    _sectionPagingController.addPageRequestListener((pageKey) {
      cubit.getAllSections(_sectionPagingController, pageKey);
    });
  }

  @override
  void initState() {
    super.initState();
    _getSections();
  }

  @override
  void dispose() {
    super.dispose();
    _sectionPagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => _sectionPagingController.refresh(),
      color: AppColors.lightPrimaryColor,
      child: PagedGridView<int, SectionModel>(
        showNoMoreItemsIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        showNewPageErrorIndicatorAsGridChild: false,
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 40.h,top: 15.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.w,
          crossAxisSpacing: 10.w,
          childAspectRatio: .75,
        ),
        pagingController: _sectionPagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => SectionItem(section: item),
          firstPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageErrorIndicatorBuilder: (context) => const MyProgress(),
          noItemsFoundIndicatorBuilder: (context) => const EmptyWidget(
              text: 'No sections', image: AppImages.emptyMedia),
          firstPageErrorIndicatorBuilder: (context) =>TeamsErrorView(message: _sectionPagingController.error),
        ),
      ),
    );
  }
}
