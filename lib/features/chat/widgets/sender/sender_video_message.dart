import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/seen_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/video_widget.dart';

class VideoMessage extends StatelessWidget {
  const VideoMessage({Key? key, required this.message}) : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.w, top: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              ForwardButton(message: message),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      height: context.width * .7,
                      width: context.width * .7,
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsetsDirectional.all(3.h),
                      decoration: const BoxDecoration(
                        color: AppColors.lightPrimaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        child: BlocBuilder<ChatCubit, ChatState>(
                          buildWhen: (previous, current) =>
                              current is UploadVideoSuccess &&
                              current.videoVirtualId ==
                                  message.video!.videoVirtualId,
                          builder: (context, state) => Stack(
                            alignment: Alignment.center,
                            children: [
                              VideoWidget(
                                video: message.video!,
                                key: ObjectKey(message.virtualId),
                              ),
                              Visibility(
                                  visible: message.video!.videoUrl == null,
                                  replacement: const SizedBox.shrink(),
                                  child: const MyProgress(
                                      color: AppColors.lightPrimaryColor)),
                              Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      bottom: 5, end: 5),
                                  child: SeenWidget(
                                      messageId: message.virtualId,
                                      isSeen: message.seen)),
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 3.h,
                  ),
                  TimeWidget(dateTime: message.dateTime.toDate()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
