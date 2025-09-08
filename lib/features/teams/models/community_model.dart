import 'package:equatable/equatable.dart';

class CommunityModel extends Equatable {
  final int id;
  final String name;
  final String image;
  final bool? isJoined;
  final String? type;
  final List<CommunityModel> subChannels;

  const CommunityModel({
    required this.id,
    required this.name,
    required this.image,
    required this.subChannels,
    required this.type,
    required this.isJoined,
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
      // subChannels: json['sub_communities'] != null &&
      //         json['sub_communities'].isNotEmpty
      //     ? List<CommunityModel>.from(
      //         json['sub_communities'].map((e) => CommunityModel.fromJson(e)))
      //     : []
      subChannels: subSubList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, image, subChannels, isJoined, type];
}
