import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/seen_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';

class SenderTextMessage extends StatelessWidget {
  const SenderTextMessage({Key? key, required this.message}) : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 8.h, 10.w, 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ForwardButton(message: message),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: context.width * 0.7,
                      minWidth: context.width * .18),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: AppColors.lightPrimaryColor,
                      borderRadius: BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(15.r),
                          bottomStart: Radius.circular(15.r),
                          topStart: Radius.circular(15.r))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: SelectableText(
                          message.text!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: AppFonts.arial,
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SeenWidget(
                          messageId: message.virtualId, isSeen: message.seen),
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
      ),
    );
  }
}
