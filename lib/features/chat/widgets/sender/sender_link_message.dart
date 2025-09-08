import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/link_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/seen_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';

class SenderLinkMessage extends StatelessWidget {
  const SenderLinkMessage({Key? key, required this.message}) : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.w, top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ForwardButton(message: message),
              Container(
                width: context.width * .7,
                decoration: BoxDecoration(
                  color: AppColors.lightPrimaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(child: LinkWidget(url: message.text!)),
                    Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 8, end: 8),
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
          TimeWidget(dateTime: message.dateTime.toDate()),
        ],
      ),
    );
  }
}
