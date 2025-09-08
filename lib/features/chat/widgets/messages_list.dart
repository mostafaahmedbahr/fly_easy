import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/my_message.dart';
import 'package:new_fly_easy_new/features/chat/widgets/other_message.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({Key? key, required this.scrollController})
      : super(key: key);
  final ScrollController scrollController;

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  ChatCubit get cubit => ChatCubit.get(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (previous, current) =>
          current is SendMessage ||
          current is GetMessagesLoad ||
          current is GetMessages ||
          current is GetMessagesError ||
          current is LoadMore ||
          current is PickImages ||
          current is PickVideo ||
          current is PickFileSuccess ||
          current is SaveRecordSuccess,
      builder: (context, state) => state is GetMessagesLoad
          ? const Center(
              child: MyProgress(),
            )
          : cubit.messages.isNotEmpty
              ? Column(
                  children: [
                    state is LoadMore
                        ? Container(
                            margin: EdgeInsets.only(top: 10.h),
                            height: 20,
                            width: 20,
                            child: const MyProgress(),
                          )
                        : const SizedBox.shrink(),
                    Expanded(
                      child: ListView.custom(
                        physics: const AlwaysScrollableScrollPhysics(),
                        childrenDelegate: SliverChildBuilderDelegate(
                          addAutomaticKeepAlives: true,
                          findChildIndexCallback: (key) {
                            final ValueKey<String> valueKey =
                                key as ValueKey<String>;
                            return cubit.messages.indexWhere(
                                (MessageModel message) =>
                                    message.virtualId == valueKey.value);
                          },
                          childCount: cubit.messages.length,
                          (context, index) =>
                              _isMyMessage(cubit.messages[index])
                                  ? MyMessage(
                                      key: ValueKey<String>(
                                          cubit.messages[index].virtualId),
                                      isNewDate: _isNewDate(index),
                                      message: cubit.messages[index])
                                  : OtherMessage(
                                      key: ValueKey<String>(
                                          cubit.messages[index].virtualId),
                                      message: cubit.messages[index],
                                      isNewDate: _isNewDate(index),
                                      isSameAsPrev: _isSameAsPrev(index)),
                        ),
                        reverse: true,
                        controller: widget.scrollController,
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
    );
  }


  bool _isMyMessage(MessageModel message) =>
      message.senderId == HiveUtils.getUserData()!.id;

  bool _isNewDate(int messageIndex) {
    if (messageIndex == cubit.messages.length - 1) {
      return true;
    } else {
      DateTime currentDate = cubit.messages[messageIndex].dateTime.toDate();
      DateTime prevDate = cubit.messages[messageIndex + 1].dateTime.toDate();
      if (prevDate.day != currentDate.day ||
          prevDate.year != currentDate.year ||
          prevDate.month != currentDate.month) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool _isSameAsPrev(int index) {
    if (index == cubit.messages.length - 1) {
      return false;
    } else {
      return (cubit.messages[index].senderId ==
          cubit.messages[index + 1].senderId);
    }
  }

}
