import 'package:equatable/equatable.dart';

class CommunityModel extends Equatable {
  final int id;
  final String name;
  final String image;
  final bool? isJoined;
  final String? type;
  final int notificationsCount;
  final List<CommunityModel> subChannels;

  const CommunityModel({
    required this.id,
    required this.name,
    required this.image,
    required this.subChannels,
    required this.type,
    required this.isJoined,
    this.notificationsCount = 0,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json) {
    List<CommunityModel> subSubList = [];
    if (json['sub_communities'] != null && json['sub_communities'].isNotEmpty) {
      json['sub_communities'].forEach((subSub) {
        if (subSub['is_joined'] != 'no') {
          subSubList.add(CommunityModel.fromJson(subSub));
        }
      });
    }
    return CommunityModel(
      id: json['id'],
      name: json['name'],
      image: json['logo'],
      type: json['group'],
      isJoined: json['is_joined'] != 'no',
      notificationsCount: json['notify_counter'] ?? 0,
      subChannels: subSubList,
    );
  }

  @override
  List<Object?> get props => [name, image, subChannels, isJoined, type, notificationsCount];
}
