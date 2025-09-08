import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  String phone;
  @HiveField(4)
  String token;
  @HiveField(5)
  String image;
  @HiveField(6)
  int addedTeamsCount;
  @HiveField(7)
  int addedMembersCount;
  @HiveField(8)
  int addedCommunitiesCount;
  @HiveField(9)
  int addedSubCommunitiesCount;
  @HiveField(10)
  int remainsTeamsCount;
  @HiveField(11)
  int remainsCommunitiesCount;
  @HiveField(12)
  int remainsSubCommunitiesCount;
  @HiveField(13)
  int remainsMembersCount;
  @HiveField(14)
  String countryCode;
  @HiveField(15)
  String? workId;
  @HiveField(16)
  String? company;

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.countryCode,
      required this.token,
      required this.image,
      required this.addedTeamsCount,
      required this.addedCommunitiesCount,
      required this.addedSubCommunitiesCount,
      required this.addedMembersCount,
      required this.remainsTeamsCount,
      required this.remainsCommunitiesCount,
      required this.remainsSubCommunitiesCount,
      required this.remainsMembersCount,
      this.workId,
      this.company});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        countryCode: json['country_code'],
        token: json['token'] ?? CacheUtils.getToken(),
        image: json['profile_image'],
        addedTeamsCount: json['added_teams_count'],
        addedCommunitiesCount: json['added_communities_count'],
        addedSubCommunitiesCount: json['added_sub_communities_count'],
        addedMembersCount: json['added_members_count'],
        remainsTeamsCount: json['remains_teams_count'],
        remainsCommunitiesCount: json['remains_communities_count'],
        remainsSubCommunitiesCount: json['remains_sub_communities_count'],
        remainsMembersCount: json['remains_members_count'],
        workId: json['work_id'],
        company: json['company']);
  }
}
