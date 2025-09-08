import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/chat/widgets/message_types/link_widget.dart';

class ChatMedialLink extends StatelessWidget {
  const ChatMedialLink({Key? key,required this.link}) : super(key: key);
final String link;
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: context.width * .6,
      decoration: BoxDecoration(
        color: AppColors.lightSecondaryColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child:  LinkWidget(url: link),
    );
  }
}
