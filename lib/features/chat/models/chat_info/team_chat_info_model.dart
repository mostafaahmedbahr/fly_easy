import 'package:equatable/equatable.dart';

class TeamChatInfoModel extends Equatable {
  final dynamic id;  // teamId or userId
  final String image;
  final String name;
  final bool isTeam;
  final dynamic userChatId;

  const TeamChatInfoModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isTeam,
    this.userChatId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [name, image, id, isTeam,userChatId];
}
