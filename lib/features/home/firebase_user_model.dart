import 'package:new_fly_easy_new/features/chat/models/message_model.dart';

class FirebaseUserModel {
  final int id;
  final String name;
  final String image;
  final MessageModel? lastMessage;

  FirebaseUserModel({
    required this.id,
    required this.name,
    required this.image,
    this.lastMessage,
  });

  factory FirebaseUserModel.fromJson(Map<String, dynamic> json,{MessageModel? message}) {
    return FirebaseUserModel(
        id: json['id'], name: json['name'], image: json['image'],lastMessage: message);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
