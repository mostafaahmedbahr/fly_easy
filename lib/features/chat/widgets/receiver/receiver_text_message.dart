import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';

class ReceiverTextMessage extends StatelessWidget {
  const ReceiverTextMessage(
      {Key? key,
      required this.message,
      required this.isSameSender,
      required this.isGroup})
      : super(key: key);
  final MessageModel message;
  final bool isSameSender;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    if (isGroup) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
            start: isSameSender ? 45.w : 5.w, top: isSameSender ? 0 : 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !isSameSender,
                  replacement: const SizedBox.shrink(),
                  child: CircleNetworkImage(
                      width: 45.w, imageUrl: message.senderImage!),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !isSameSender,
                      replacement: const SizedBox.shrink(),
                      child: Text(
                        textAlign: TextAlign.start,
                        message.senderName!,
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          // margin: EdgeInsetsDirectional.fromSTEB(3.w, 0, 0, 0.w),
                          constraints: BoxConstraints(
                              maxWidth: context.width * 0.7,
                              minWidth: context.width * .18),
                          decoration: BoxDecoration(
                              color: AppColors.lightSecondaryColor,
                              borderRadius: BorderRadiusDirectional.only(
                                  bottomEnd: Radius.circular(15.r),
                                  bottomStart: Radius.circular(15.r),
                                  topEnd: Radius.circular(15.r))),
                          child: SelectableText(
                            message.text!,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        TimeWidget(dateTime: message.dateTime.toDate()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            ForwardButton(message: message),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: 7.w,top: isSameSender?5.h:10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  // margin: EdgeInsetsDirectional.fromSTEB(3.w, 0, 0, 0.w),
                  constraints: BoxConstraints(
                      maxWidth: context.width * 0.7, minWidth: context.width * .18),
                  decoration: BoxDecoration(
                      color: AppColors.lightSecondaryColor,
                      borderRadius: BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(15.r),
                          bottomStart: Radius.circular(15.r),
                          topEnd: Radius.circular(15.r))),
                  child: SelectableText(
                    message.text!,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                TimeWidget(dateTime: message.dateTime.toDate()),
              ],
            ),
            ForwardButton(message: message),
          ],
        ),
      );
    }
  }
}
