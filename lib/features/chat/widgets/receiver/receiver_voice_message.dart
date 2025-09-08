import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/audio_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';

class ReceiverAudioMessage extends StatefulWidget {
  const ReceiverAudioMessage(
      {Key? key,
      required this.message,
      required this.isSameSender,
      required this.isGroup})
      : super(key: key);
  final MessageModel message;
  final bool isSameSender;
  final bool isGroup;

  @override
  State<ReceiverAudioMessage> createState() => _ReceiverAudioMessageState();
}

class _ReceiverAudioMessageState extends State<ReceiverAudioMessage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.isGroup) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
            start: widget.isSameSender ? 45.w : 5.w,
            top: widget.isSameSender ? 0 : 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
                visible: !widget.isSameSender,
                replacement: const SizedBox.shrink(),
                child: CircleNetworkImage(
                    width: 40.w, imageUrl: widget.message.senderImage!)),
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
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          constraints: BoxConstraints(maxWidth: context.width * .7),
                          decoration: BoxDecoration(
                            color: AppColors.lightSecondaryColor,
                            borderRadius: BorderRadiusDirectional.only(
                                bottomEnd: Radius.circular(10.r),
                                bottomStart: Radius.circular(10.r),
                                topEnd: Radius.circular(10.r)),
                          ),
                          child: AudioWidget(
                            voice: widget.message.record!,
                          ),
                        ),
                        TimeWidget(
                            dateTime: widget.message.dateTime.toDate()),
                      ],
                    ),
                    ForwardButton(message: widget.message),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: 7.w, top: widget.isSameSender ? 5.h : 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: AlignmentDirectional.topStart,
                  constraints: BoxConstraints(maxWidth: context.width * .7),
                  decoration: BoxDecoration(
                    color: AppColors.lightSecondaryColor,
                    borderRadius: BorderRadiusDirectional.only(
                        bottomEnd: Radius.circular(10.r),
                        bottomStart: Radius.circular(10.r),
                        topEnd: Radius.circular(10.r)),
                  ),
                  child: AudioWidget(
                    voice: widget.message.record!,
                    key: ObjectKey(widget.message.virtualId),
                  ),
                ),
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
