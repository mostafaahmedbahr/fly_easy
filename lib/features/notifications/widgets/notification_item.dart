import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/notifications/model/notifications_model.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.notification})
      : super(key: key);
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onNotificationPressed(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: notification.userImage,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              placeholder: (context, url) => ClipOval(
                  child: Container(
                height: context.width * .15,
                width: context.width * .15,
                color: Colors.grey.withOpacity(.5),
              )),
              fadeInCurve: Curves.ease,
              fadeInDuration: const Duration(milliseconds: 300),
              fit: BoxFit.cover,
              height: context.width * .12,
              width: context.width * .12,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  notification.message,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontSize: 14.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Text(
                      notification.date,
                      style: Theme.of(context).textTheme.titleSmall,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onNotificationPressed(BuildContext context) {
    late TeamChatInfoModel chatInfo;
    if (notification.type == '0') {
      chatInfo = TeamChatInfoModel(
        id: notification.userId,
        name: notification.userName!,
        image: notification.userImage,

        userChatId: notification.chatUserId,
        isTeam: false,
        // userChatId: notification.id,
      );
    } else {
      chatInfo = TeamChatInfoModel(
        id: notification.teamId,
        name: notification.teamName!,
        image: notification.teamImage!,
        isTeam: true,
      );
    }
    context.push(Routes.chat, arg: chatInfo);
  }
}
