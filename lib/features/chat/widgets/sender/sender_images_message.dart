import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/images_grid_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/seen_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';

class SenderImagesMessage extends StatelessWidget {
  const SenderImagesMessage({Key? key, required this.message})
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
                Container(
                  margin: EdgeInsetsDirectional.only(end: 10.w, top: 15.h),
                  width: context.width * .72,
                  padding:
                      EdgeInsets.all(message.images!.length > 1 ? 4.h : 1.h),
                  decoration: BoxDecoration(
                      color: AppColors.lightPrimaryColor.withOpacity(.2),
                      borderRadius: BorderRadius.all(Radius.circular(15.r))),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      ImagesGridMessage(images: message.images!),
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
