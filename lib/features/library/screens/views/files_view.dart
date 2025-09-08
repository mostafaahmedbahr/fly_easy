import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/error_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/library/bloc/section_bloc/section_cubit.dart';
import 'package:new_fly_easy_new/features/library/models/file_model.dart';
import 'package:new_fly_easy_new/features/library/widgets/media_file.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FilesView extends StatefulWidget {
  const FilesView({Key? key, required this.filesPagingController})
      : super(key: key);
  final PagingController<int, FileModel> filesPagingController;

  @override
  State<FilesView> createState() => _FilesViewState();
}

class _FilesViewState extends State<FilesView>
    with AutomaticKeepAliveClientMixin {
  SectionCubit get cubit => SectionCubit.get(context);

  void _getFiles() {
    widget.filesPagingController.addPageRequestListener((pageKey) {
      cubit.getFiles(widget.filesPagingController, pageKey);
    });
  }

  @override
  void initState() {
    _getFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: ()async =>widget.filesPagingController.refresh() ,
      color: AppColors.lightPrimaryColor,
      child: PagedGridView<int, FileModel>(
        showNoMoreItemsIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        showNewPageErrorIndicatorAsGridChild: false,
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 40.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: .7,
        ),
        pagingController: widget.filesPagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => MediaFile(file: item),
          firstPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageErrorIndicatorBuilder: (context) => const MyProgress(),
          noItemsFoundIndicatorBuilder: (context) => EmptyWidget(
              text: LocaleKeys.no_files_posted.tr(), image: AppImages.emptyMedia),
          firstPageErrorIndicatorBuilder: (context) => CustomErrorWidget(message: widget.filesPagingController.error),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
