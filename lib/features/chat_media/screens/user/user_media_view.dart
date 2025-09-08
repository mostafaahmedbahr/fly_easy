import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/user_chat_media_bloc/user_chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/widgets/chat_media_image.dart';
import 'package:new_fly_easy_new/features/chat_media/widgets/chat_media_video.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class UserChatMediaView extends StatefulWidget {
  const UserChatMediaView({Key? key}) : super(key: key);

  @override
  State<UserChatMediaView> createState() => _UserChatMediaViewState();
}

class _UserChatMediaViewState extends State<UserChatMediaView>
    with AutomaticKeepAliveClientMixin {
  UserChatMediaCubit get cubit => UserChatMediaCubit.get(context);

  @override
  void initState() {
    Future.microtask(() => cubit.getMedia());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<UserChatMediaCubit, UserChatMediaState>(
      buildWhen: (previous, current) =>
          current is GetMediaError ||
          current is GetMediaSuccess ||
          current is GetMediaLoad,
      builder: (context, state) => state is GetMediaSuccess
          ? cubit.mediaList.isNotEmpty
              ? GridView.builder(
                  padding:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 40.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) => cubit
                              .mediaList[index].type ==
                          MessageType.image.name
                      ? ChatMediaImage(
                          imageUrl: cubit.mediaList[index].imageUrl!)
                      : ChatMediaVideo(video: cubit.mediaList[index].video!),
                  itemCount: cubit.mediaList.length,
                )
              : EmptyWidget(
                  text: LocaleKeys.no_media_in_chat.tr(),
                  image: AppImages.emptyMedia)
          : const MyProgress(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
