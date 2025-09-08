import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/images_grid_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';

class ReceiverImageMessage extends StatefulWidget {
  const ReceiverImageMessage(
      {Key? key, required this.message, required this.isSameSender,required this.isGroup})
      : super(key: key);
  final MessageModel message;
  final bool isSameSender;
  final bool isGroup;

  @override
  State<ReceiverImageMessage> createState() => _ReceiverImageMessageState();
}

class _ReceiverImageMessageState extends State<ReceiverImageMessage> {
  ChatCubit get cubit=>ChatCubit.get(context);
  @override
  void initState() {
    super.initState();
    cubit.downloadImages(widget.message.images!);
  }
  @override
  Widget build(BuildContext context) {
    if(widget.isGroup){
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
                        textAlign: TextAlign.center,
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
                          width: context.width * .7,
                          padding:
                          EdgeInsets.all(widget.message.images!.length > 1 ? 4.h : 1.h),
                          decoration: BoxDecoration(
                              color: AppColors.lightSecondaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(15.r))),
                          child: ImagesGridMessage(images: widget.message.images!),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        TimeWidget(
                          dateTime: widget.message.dateTime.toDate(),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            ForwardButton(message: widget.message),
          ],
        ),
      );
    }else {
      return Padding(
        padding: EdgeInsetsDirectional.only(start: 7.w,top: widget.isSameSender ? 5.h: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: context.width * .7,
                  padding:
                  EdgeInsets.all(widget.message.images!.length > 1 ? 4.h : 1.h),
                  decoration: BoxDecoration(
                      color: AppColors.lightSecondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(15.r))),
                  child: ImagesGridMessage(images: widget.message.images!),
                ),
                SizedBox(
                  height: 3.h,
                ),
                TimeWidget(
                  dateTime: widget.message.dateTime.toDate(),
                ),
              ],
            ),
            ForwardButton(message: widget.message),
          ],
        ),
      );
    }
  }
}
