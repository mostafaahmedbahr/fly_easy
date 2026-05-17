import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final dynamic id;
  final dynamic userId;
  final dynamic userImage;
  final dynamic userEmail;
  final dynamic userName;
  final dynamic chatUserId;
  final dynamic teamId;
  final dynamic teamImage;
  final dynamic teamName;
  final dynamic message;
  final dynamic type;
  final dynamic date;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.userImage,
    required this.userEmail,
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
        userEmail: json['email'],
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
        userEmail,
        chatUserId,
        date,
        teamImage,
        teamId,
        teamName,
        userName,
        type
      ];
}
