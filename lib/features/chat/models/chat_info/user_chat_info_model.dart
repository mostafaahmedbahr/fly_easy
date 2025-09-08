import 'package:equatable/equatable.dart';

class UserChatInfoModel extends Equatable {
  final String userId;
  final String userName;
  final String userImage;

  const UserChatInfoModel({
    required this.userId,
    required this.userImage,
    required this.userName
});

  @override
  // TODO: implement props
  List<Object?> get props => [userImage,userName,userId];

}