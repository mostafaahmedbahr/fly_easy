import 'package:equatable/equatable.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';

class ChannelDetails extends Equatable {
  final int id;
  final String name;
  final String logo;
  final int memberType; //1 guest  2 admin  3 moderator
  final List<MemberModel> moderators;
  final List<MemberModel> guests;
  final MemberModel admin;

  const ChannelDetails({
    required this.id,
    required this.name,
    required this.guests,
    required this.memberType,
    required this.moderators,
    required this.logo,
    required this.admin,
  });

  factory ChannelDetails.fromJson(Map<String, dynamic> json) {
    List<MemberModel> currentGuests = [];
    List<MemberModel> currentModerators = [];
    json['guests'].forEach((guest) {
      if(guest['is_joined']=='yes'){
        currentGuests.add(MemberModel.fromJson(guest));
      }
    });
    json['moderators'].forEach((moderator) {
      if(moderator['is_joined']=='yes'){
        currentModerators.add(MemberModel.fromJson(moderator));
      }
    });
    return ChannelDetails(
        id: json['id'],
        name: json['name'],
        memberType: json['member_group'],
        guests: currentGuests,
        admin: MemberModel.fromJson(json['creator'][0]),
        moderators: currentModerators,
        logo: json['logo'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name,logo,id,moderators,guests,memberType];
}
