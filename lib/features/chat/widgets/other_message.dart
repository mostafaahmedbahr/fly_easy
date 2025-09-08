import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/date_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/receiver/receiver_contact_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/receiver/receiver_file_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/receiver/receiver_image_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/receiver/receiver_link_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/receiver/receiver_location_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/receiver/receiver_text_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/receiver/receiver_video_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/receiver/receiver_voice_message.dart';

class OtherMessage extends StatelessWidget {
  const OtherMessage(
      {required Key key, required this.message, required this.isSameAsPrev, required this.isNewDate})
      : super(key: key);
  final MessageModel message;
  final bool isSameAsPrev;
  final bool isNewDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isNewDate)
          Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 15.h),
              child: DateWidget(
                  dateTime: message
                      .dateTime))
        else
          const SizedBox.shrink(),
        (message.type == MessageType.text.name) ?
        ReceiverTextMessage(
          message: message,
          isSameSender: isSameAsPrev,
          isGroup: ChatCubit
              .get(context)
              .userId == null,
        ) :
        (message.type == MessageType.image.name) ?
        ReceiverImageMessage(
          message: message,
          isSameSender: isSameAsPrev,
          isGroup: ChatCubit
              .get(context)
              .userId == null,
        ) :
        (message.type == MessageType.video.name) ?
        ReceiverVideoMessage(
          message: message,
          isSameSender: isSameAsPrev,
          isGroup: ChatCubit
              .get(context)
              .userId == null,
        ) :
        (message.type == MessageType.voice.name) ?
        ReceiverAudioMessage(
          message: message,
          isSameSender: isSameAsPrev,
          isGroup: ChatCubit
              .get(context)
              .userId == null,
        ) :
        (message.type == MessageType.contact.name) ?
        ReceiverContactMessage(
          message: message,
          isSameSender: isSameAsPrev,
          isGroup: ChatCubit
              .get(context)
              .userId == null,
        ) :
        (message.type == MessageType.file.name) ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: message.files!
              .map((e) =>
              ReceiverFileMessage(
                isSameSender: isSameAsPrev,
                message: message,
                isGroup: ChatCubit
                    .get(context)
                    .userId == null,
              ))
              .toList(),
        ) :
        (message.type == MessageType.link.name) ?
        ReceiverLinkMessage(
          message: message,
          isSameSender: isSameAsPrev,
          isGroup: ChatCubit
              .get(context)
              .userId == null,
        ) : (message.type == MessageType.location.name) ?
        ReceiverLocationMessage(
            message: message, isSameSender: isSameAsPrev, isGroup: ChatCubit
            .get(context)
            .userId == null):
        const SizedBox.shrink(),
      ],
    );
  }
}
