import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/forward_messages/models/forward_info_model.dart';

class ForwardButton extends StatelessWidget {
  const ForwardButton({Key? key, required this.message}) : super(key: key);
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          context.push(Routes.forwardMessageScreen,
              arg: ForwardInfoModel(
                  messages: [message],
                  teamId: ChatCubit.get(context).teamId,
                  userId: ChatCubit.get(context).userId));
        },
        icon: const Icon(
          Icons.reply,
          color: Colors.grey,
        ));
  }
}
