import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final int id;
  final int userId;
  final String userImage;
  final String? userName;
  final String? chatUserId;
  final int? teamId;
  final String? teamImage;
  final String? teamName;
  final String message;
  final String type;
  final String date;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.userImage,
    required this.userName,
    required this.chatUserId,
    required this.teamId,
    required this.teamImage,
    required this.teamName,
    required this.message,
    required this.type,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id'],
        userId: json['from'],
        userImage: json['profile_image'],
        userName: json['username'],
        chatUserId: json['chat_user_id'],
        teamId: json['channel_id'],
        teamImage: json['channel_image'],
        teamName: json['Channelname'],
        message: json['message'],
        type: json['type'],
        date: json['created_at']);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        message,
        userId,
        userImage,
        chatUserId,
        date,
        teamImage,
        teamId,
        teamName,
        userName,
        type
      ];
}
