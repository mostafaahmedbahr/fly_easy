import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/custom_network_image.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/video_widget.dart';

class ReceiverVideoMessage extends StatefulWidget {
  const ReceiverVideoMessage(
      {Key? key,
      required this.message,
      required this.isSameSender,
      required this.isGroup})
      : super(key: key);
  final MessageModel message;
  final bool isSameSender;
  final bool isGroup;

  @override
  State<ReceiverVideoMessage> createState() => _ReceiverVideoMessageState();
}

class _ReceiverVideoMessageState extends State<ReceiverVideoMessage> with AutomaticKeepAliveClientMixin{
  @override
  void initState() {
    super.initState();
    // sl<DownloadManager>().downloadVideo(widget.message.video!.videoUrl!, widget.message.video!.videoVirtualId!);
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.isGroup) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
            start: widget.isSameSender ? 45.w : 5.w, top: widget.isSameSender ? 0 : 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !widget.isSameSender,
                  replacement: const SizedBox.shrink(),
                  child: CustomNetworkImage(
                      width: 40.w, imageUrl: widget.message.senderImage!),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !widget.isSameSender,
                      replacement: const SizedBox.shrink(),
                      child: Text(
                        textAlign: TextAlign.start,
                        widget.message.senderName!,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontFamily: AppFonts.arial,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            height: context.width * .67,
                            width: context.width * .67,
                            alignment: AlignmentDirectional.center,
                            padding: EdgeInsetsDirectional.all(3.h),
                            decoration: const BoxDecoration(
                              color: AppColors.lightSecondaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              child: VideoWidget(
                                video: widget.message.video!,
                                // key: ObjectKey(message.virtualId),
                              ),
                            )),
                        TimeWidget(dateTime: widget.message.dateTime.toDate()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            ForwardButton(message: widget.message),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsetsDirectional.only(
            start: 7.w, top: widget.isSameSender ? 5.h : 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    height: context.width * .67,
                    width: context.width * .67,
                    alignment: AlignmentDirectional.center,
                    padding: EdgeInsetsDirectional.all(3.h),
                    decoration: const BoxDecoration(
                      color: AppColors.lightSecondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: VideoWidget(
                        video: widget.message.video!,
                        key: ObjectKey(widget.message.virtualId),
                      ),
                    )),
                TimeWidget(dateTime: widget.message.dateTime.toDate()),
              ],
            ),
            ForwardButton(message: widget.message),

          ],
        ),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
