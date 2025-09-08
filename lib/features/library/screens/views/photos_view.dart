import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/error_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/library/bloc/section_bloc/section_cubit.dart';
import 'package:new_fly_easy_new/features/library/models/image_model.dart';
import 'package:new_fly_easy_new/features/library/widgets/media_image.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PhotosView extends StatefulWidget {
  const PhotosView({Key? key, required this.imagesPagingController})
      : super(key: key);
  final PagingController<int, ImageModel> imagesPagingController;

  @override
  State<PhotosView> createState() => _PhotosViewState();
}

class _PhotosViewState extends State<PhotosView>
    with AutomaticKeepAliveClientMixin {
  SectionCubit get cubit => SectionCubit.get(context);

  void _getImages() {
    widget.imagesPagingController.addPageRequestListener((pageKey) {
      cubit.getImages(widget.imagesPagingController, pageKey);
    });
  }

  @override
  void initState() {
    _getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: () async => widget.imagesPagingController.refresh(),
      color: AppColors.lightPrimaryColor,
      child: PagedGridView<int, ImageModel>(
        showNewPageErrorIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 40.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 1,
        ),
        pagingController: widget.imagesPagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => MediaPhoto(image: item),
          firstPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageErrorIndicatorBuilder: (context) => const MyProgress(),
          noItemsFoundIndicatorBuilder: (context) => EmptyWidget(
              text: LocaleKeys.no_photos_posted.tr(),
              image: AppImages.emptyMedia),
          firstPageErrorIndicatorBuilder: (context) => CustomErrorWidget(message: widget.imagesPagingController.error),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
