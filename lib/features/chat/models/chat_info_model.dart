import 'package:equatable/equatable.dart';

import '../../teams/models/community_model.dart';

class ChatInfoModel extends Equatable {
  final int teamId;
  final String image;
  final String teamName;
  final List<CommunityModel>? usersList;
  // final String communityName;

  const ChatInfoModel(
      {required this.teamId,
      // required this.communityName,
      required this.teamName,
        this.usersList,
      required this.image});

  @override
  // TODO: implement props
  List<Object?> get props => [teamName,image,teamId,usersList];
}
