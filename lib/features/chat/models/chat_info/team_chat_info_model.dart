import 'package:equatable/equatable.dart';

class TeamChatInfoModel extends Equatable {
  final dynamic id;  // teamId or userId
  final String image;
  final String name;
  final String? phone;
  final String? email;


  final bool isTeam;
  final dynamic userChatId;

  const TeamChatInfoModel({
    required this.id,
    required this.name,

    required this.image,
    required this.isTeam,
      this.phone,
      this.email,
    this.userChatId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [name, phone ,email, image, id, isTeam,userChatId];
}
