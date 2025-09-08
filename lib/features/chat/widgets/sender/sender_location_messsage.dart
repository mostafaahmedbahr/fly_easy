import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/location_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/seen_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';

class SenderLocationMessage extends StatelessWidget {
  const SenderLocationMessage({Key? key, required this.message})
      : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                ForwardButton(message: message),
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    LocationWidget(
                      margin: EdgeInsetsDirectional.only(end: 10.w, top: 15.h),
                      color: AppColors.lightPrimaryColor,
                      locationUrl: message.text!,
                    ),
                    Padding(
                        padding: const EdgeInsetsDirectional.only(
                            bottom: 10, end: 10),
                        child: SeenWidget(
                          messageId: message.virtualId,
                          isSeen: message.seen,
                          color: AppColors.lightPrimaryColor,
                        )),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            Padding(
                padding: EdgeInsetsDirectional.only(end: 10.w),
                child: TimeWidget(
                  dateTime: message.dateTime.toDate(),
                ))
          ],
        ),
      ],
    );
  }
}
