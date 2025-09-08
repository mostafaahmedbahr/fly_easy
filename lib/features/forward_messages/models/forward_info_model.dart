import 'package:new_fly_easy_new/features/chat/models/message_model.dart';

class ForwardInfoModel {
  final List<MessageModel> messages;
  final String? teamId;
  final String? userId;

  ForwardInfoModel({
    required this.messages,
    this.teamId,
    this.userId,
  });
}
