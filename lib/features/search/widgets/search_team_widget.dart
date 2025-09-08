import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';

class SearchTeamWidget extends StatelessWidget {
  const SearchTeamWidget({Key? key,required this.team}) : super(key: key);
  final TeamModel team;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push(Routes.chat,
            arg: TeamChatInfoModel(
              id: team.id,
              image: team.image,
              name: team.name,
              isTeam: true,
            ));
      },
      leading: CircleNetworkImage(imageUrl: team.image, width: 40.w),
      title: Text(
        team.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      enableFeedback: true,
      enabled: true,
    );
  }
}
