import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/error_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/library/bloc/section_bloc/section_cubit.dart';
import 'package:new_fly_easy_new/features/library/models/sound_model.dart';
import 'package:new_fly_easy_new/features/library/widgets/media_sound.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SoundsView extends StatefulWidget {
  const SoundsView({Key? key, required this.soundsPagingController})
      : super(key: key);
  final PagingController<int, SoundModel> soundsPagingController;

  @override
  State<SoundsView> createState() => _SoundsViewState();
}

class _SoundsViewState extends State<SoundsView>
    with AutomaticKeepAliveClientMixin {
  SectionCubit get cubit => SectionCubit.get(context);

  void _getSounds() {
    widget.soundsPagingController.addPageRequestListener((pageKey) {
      cubit.getSounds(widget.soundsPagingController, pageKey);
    });
  }

  @override
  void initState() {
    _getSounds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator.adaptive(
      onRefresh: () async => widget.soundsPagingController.refresh(),
      color: AppColors.lightPrimaryColor,
      child: PagedGridView<int, SoundModel>(
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
        pagingController: widget.soundsPagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) => MediaSound(sound: item),
          firstPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageProgressIndicatorBuilder: (context) => const MyProgress(),
          newPageErrorIndicatorBuilder: (context) => const MyProgress(),
          noItemsFoundIndicatorBuilder: (context) => EmptyWidget(
              text: LocaleKeys.no_sounds_posted.tr(),
              image: AppImages.emptyMedia),
          firstPageErrorIndicatorBuilder: (context) => CustomErrorWidget(message: widget.soundsPagingController.error),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
