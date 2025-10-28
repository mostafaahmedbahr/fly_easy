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
import 'package:contacts_service_plus/contacts_service_plus.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    required this.userChat,
    this.contact, // Single contact instead of list
  });

  final UserChatModel userChat;
  final Contact? contact; // Single contact parameter

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  int notificationsNum = 0;

  @override
  void initState() {
    super.initState();
    notificationsNum = widget.userChat.newMessagesNum;
    _printContactInfo(); // Print contact info for debugging
  }

  void _printContactInfo() {
    print("📞 ChatWidget for backend name: ${widget.userChat.name}");

    if (widget.contact != null) {
      print("✅ Using CONTACT name: ${widget.contact!.displayName}");
      if (widget.contact!.phones != null && widget.contact!.phones!.isNotEmpty) {
        print("📱 Contact phone: ${widget.contact!.phones!.first.value}");
      }
    } else {
      print("❌ No contact found, using backend name");
    }
  }

  // Get display name - contact name first, then backend name between brackets
  String get _displayName {
    if (widget.contact != null) {
      return "${widget.contact!.displayName}";
      //return "${widget.contact!.displayName} (${widget.userChat.name})";
    }
    return widget.userChat.name;
  }

  // Get display phone - show phone number if available
  String? get _displayPhone {
    if (widget.contact != null &&
        widget.contact!.phones != null &&
        widget.contact!.phones!.isNotEmpty) {
      return widget.contact!.phones!.first.value;
    }
    return widget.userChat.phone;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalAppCubit, GlobalAppState>(
      listenWhen: (previous, current) =>
      (current is ReceiveUserNotification &&
          current.userId.toString() == widget.userChat.userId.toString()) ||
          (current is ClearUserChatNotifications &&
              current.userId.toString() == widget.userChat.userId.toString()),
      listener: _blocListener,
      child: Container(
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
                    // Display contact name if available with backend name in brackets
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _displayName,
                            style: Theme.of(context).textTheme.labelMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // علامة صح خضراء إذا وجد تطابق
                        if (widget.contact != null)
                          Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 18.sp,
                            ),
                          ),
                      ],
                    ),

                    // Display phone number if available
                    if (_displayPhone != null && _displayPhone!.isNotEmpty)
                      Text(
                        _displayPhone!,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontSize: 10.sp, color: Colors.grey),
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

                        // Display contact icon if contact exists
                        if (widget.contact != null)
                          Row(
                            children: [
                              Icon(
                                Icons.contact_phone,
                                color: Colors.green,
                                size: 16.sp,
                              ),
                              SizedBox(width: 5.w),
                            ],
                          ),

                        IconButton(
                          icon: const Icon(IconlyLight.chat),
                          onPressed: () {
                            context.push(Routes.chat,
                                arg: TeamChatInfoModel(
                                  id: widget.userChat.userId,
                                  image: widget.userChat.image,
                                  name: _displayName, // Use the display name here too
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

  void _blocListener(BuildContext context, GlobalAppState state) {
    if (state is ReceiveUserNotification &&
        state.userId.toString() == widget.userChat.userId.toString()) {
      setState(() {
        notificationsNum++;
      });
    } else if (state is ClearUserChatNotifications &&
        state.userId.toString() == widget.userChat.userId.toString()) {
      setState(() {
        notificationsNum = 0;
      });
    }
  }
}