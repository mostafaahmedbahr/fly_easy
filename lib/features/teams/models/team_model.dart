import 'package:equatable/equatable.dart';
import 'package:new_fly_easy_new/features/teams/models/community_model.dart';

class TeamModel extends Equatable {
  final int id;
  final String name;
  final String image;
  final int membersNumber;
  final int groupsNumber;
  final bool? isJoined;
  final String? type;
  final int notificationsCount;
  final List<CommunityModel> communities;

  const TeamModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.groupsNumber,
      required this.membersNumber,
      required this.communities,
      required this.notificationsCount,
      required this.isJoined,
      required this.type});

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    List<CommunityModel> subList = [];
    if (json['communities'] != null && json['communities'].isNotEmpty) {
      json['communities'].forEach((subChannel) {
        if (subChannel['message']==null){
          subList.add(CommunityModel.fromJson(subChannel));
        }
      });
    }
    return TeamModel(
        id: json['id'],
        name: json['name'],
        image: json['logo'],
        membersNumber: json['members_count'] ?? 0,
        groupsNumber: json['communities_count'] ?? 0,
        notificationsCount: json['notify_counter'] ?? 0,
        type: json['group'] ?? '',
        isJoined: json['is_joined'] != 'yes',
        communities: subList ?? []);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        image,
        membersNumber,
        groupsNumber,
        communities,
        isJoined,
        type,
        notificationsCount,
      ];
}

enum UserType { guest, moderator, admin }
