import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/error_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/chat_media/widgets/chat_media_video.dart';
import 'package:new_fly_easy_new/features/library/bloc/section_bloc/section_cubit.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VideosView extends StatefulWidget {
  const VideosView({Key? key, required this.videosPagingController})
      : super(key: key);
  final PagingController<int, VideoModel> videosPagingController;

  @override
  State<VideosView> createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView>
    with AutomaticKeepAliveClientMixin {
  SectionCubit get cubit => SectionCubit.get(context);

  void _getImages() {
    widget.videosPagingController.addPageRequestListener((pageKey) {
      cubit.getVideos(widget.videosPagingController, pageKey);
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
      onRefresh: ()async => widget.videosPagingController.refresh(),
      color: AppColors.lightPrimaryColor,
      child: PagedGridView<int, VideoModel>(
        showNoMoreItemsIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        showNewPageErrorIndicatorAsGridChild: false,
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 40.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 1,
        ),
        pagingController: widget.videosPagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => ChatMediaVideo(video: item),
          firstPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageErrorIndicatorBuilder: (context) => const MyProgress(),
          noItemsFoundIndicatorBuilder: (context) => EmptyWidget(
              text: LocaleKeys.no_videos_posted.tr(),
              image: AppImages.emptyMedia),
          firstPageErrorIndicatorBuilder: (context) => CustomErrorWidget(message: widget.videosPagingController.error),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
