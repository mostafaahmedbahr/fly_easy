import 'dart:io';

class ChatImageModel {
  File? file;
  String? name;
  String? imageUrl;
  String? virtualId;

  ChatImageModel({
    this.file,
    this.name,
    this.imageUrl,
    this.virtualId,
  });

  factory ChatImageModel.fromJson(Map<String, dynamic> json) {
    return ChatImageModel(
        virtualId: json['id'], name: json['name'], imageUrl: json['url']);
  }

  Map<String, dynamic> toJson() =>
      {'url': imageUrl, 'id': virtualId, 'name': name};
}
