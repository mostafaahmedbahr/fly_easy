import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/features/teams/models/community_model.dart';
import 'package:new_fly_easy_new/features/teams/widgets/community_item.dart';

class CommunitiesList extends StatelessWidget {
  const CommunitiesList(
      {super.key,
      required this.communities,
      required this.teamId,
      this.isArchive = false});

  final List<CommunityModel> communities;
  final int teamId;
  final bool isArchive;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => CommunityWidget(
        community: communities[index],
        isArchive: isArchive,
        teamId: teamId,
      ),
      itemCount: communities.length,
    );
  }
}
