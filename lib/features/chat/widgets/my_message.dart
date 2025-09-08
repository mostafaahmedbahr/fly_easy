import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/date_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/sender/sender_contact_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/sender/sender_file_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/sender/sender_images_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/sender/sender_link_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/sender/sender_location_messsage.dart';
import 'package:new_fly_easy_new/features/chat/widgets/sender/sender_text_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/sender/sender_video_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/sender/sender_voice_message.dart';

class MyMessage extends StatelessWidget {
  const MyMessage(
      {required Key key, required this.message, required this.isNewDate})
      : super(key: key);
  final MessageModel message;
  final bool isNewDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isNewDate)
          Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: DateWidget(dateTime: message.dateTime))
        else
          const SizedBox.shrink(),
        (message.type == MessageType.text.name)
            ? SenderTextMessage(
                message: message,
              )
            : (message.type == MessageType.image.name)
                ? SenderImagesMessage(
                    message: message,
                  )
                : (message.type == MessageType.video.name)
                    ? VideoMessage(
                        message: message,
                      )
                    : (message.type == MessageType.voice.name)
                        ? SenderVoiceMessage(
                            message: message,
                          )
                        : (message.type == MessageType.contact.name)
                            ? SenderContactMessage(
                                message: message,
                              )

                            : (message.type == MessageType.file.name)
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: message.files!
                                        .map((e) => SenderFileMessage(
                                              key: ValueKey<String>(
                                                  e.virtualId!),
                                              file: e,
                                              dateTime: message.dateTime,
                                              message: message,
                                            ))
                                        .toList(),
                                  )
                                : (message.type == MessageType.link.name)
                                    ? SenderLinkMessage(
                                        message: message,
                                      )
                                    : (message.type ==
                                            MessageType.location.name)
                                        ? SenderLocationMessage(
                                            message: message)
                                        : const SizedBox.shrink(),
      ],
    );
  }
}
