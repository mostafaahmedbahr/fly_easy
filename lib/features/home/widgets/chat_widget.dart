import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/home/models/user_chat_model.dart';
import 'package:new_fly_easy_new/features/home/widgets/user_chat_image.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:iconly/iconly.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key, required this.userChat}) : super(key: key);
  final UserChatModel userChat;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  int notificationsNum = 0;

  @override
  void initState() {
    super.initState();
    notificationsNum = widget.userChat.newMessagesNum;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalAppCubit, GlobalAppState>(
      listenWhen: (previous, current) =>
          (current is ReceiveUserNotification &&
              current.userId.toString() == widget.userChat.userId.toString()) ||
          (current is ClearUserChatNotifications &&
              current.userId.toString() == widget.userChat.userId.toString()),
      listener:_blocListener,
      child: Container(
        height: context.height * .12,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: ShapeDecoration(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.09),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 4,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              UserChatImage(
                  width: constraints.maxWidth * .2,
                  imageUrl: widget.userChat.image),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userChat.name,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Row(
                      children: [
                        BlocBuilder<GlobalAppCubit, GlobalAppState>(
                          buildWhen: (previous, current) =>
                              (current is ReceiveUserNotification &&
                                  current.userId.toString() ==
                                      widget.userChat.userId.toString()) ||
                              (current is ClearUserChatNotifications &&
                                  current.userId.toString() ==
                                      widget.userChat.userId.toString()),
                          builder: (context, state) => Text(
                            LocaleKeys.num_new_messages
                                .tr(args: [notificationsNum.toString()]),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(fontSize: 12.sp),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(IconlyLight.chat),
                          onPressed: () {
                            // HomeCubit.get(context)
                            //     .clearUserNotification(widget.userChat.id);
                            context.push(Routes.chat,
                                arg: TeamChatInfoModel(
                                  id: widget.userChat.userId,
                                  image: widget.userChat.image,
                                  name: widget.userChat.name,

                                  userChatId: widget.userChat.id,
                                  isTeam: false,
                                ));
                            setState(() {
                              notificationsNum = 0;
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context,GlobalAppState state){
    if (state is ReceiveUserNotification &&
        state.userId.toString() == widget.userChat.userId.toString()) {
      notificationsNum++;
    } else if (state is ClearUserChatNotifications &&
        state.userId.toString() == widget.userChat.userId.toString()) {
      notificationsNum = 0;
    }
  }
}

