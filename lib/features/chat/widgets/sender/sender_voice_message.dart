import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/audio_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/seen_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';

class SenderVoiceMessage extends StatelessWidget {
  const SenderVoiceMessage({Key? key, required this.message}) : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.w, top: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  ForwardButton(message: message),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    constraints: BoxConstraints(maxWidth: context.width * .73),
                    decoration: BoxDecoration(
                      color: AppColors.lightPrimaryColor,
                      borderRadius: BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(10.r),
                          bottomStart: Radius.circular(10.r),
                          topStart: Radius.circular(10.r)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: AudioWidget(
                            voice: message.record!,
                            key: ObjectKey(message.virtualId),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsetsDirectional.only(
                                bottom: 5, end: 5,),
                            child: SeenWidget(
                                messageId: message.virtualId, isSeen: message.seen)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              TimeWidget(dateTime: message.dateTime.toDate()),
            ],
          ),
        ],
      ),
    );
  }
}
