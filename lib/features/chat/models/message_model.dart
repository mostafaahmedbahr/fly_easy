import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_file_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_image_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_record_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/chat/models/contact_model.dart';

class MessageModel {
  String virtualId;
  int? senderId;
  String? senderImage;
  String? senderName;
  String type;
  Timestamp dateTime;
  String? text;
  String? messageId;
  List<ChatImageModel>? images;
  List<ChatFileModel>? files;
  VideoModel? video;
  ChatRecordModel? record;
  ContactModel? contact;
  String? location;
  bool seen;

  MessageModel({
    required this.virtualId,
    required this.type,
    required this.dateTime,
    this.messageId,
    this.senderId,
    this.senderImage,
    this.senderName,
    this.text,
    this.images,
    this.video,
    this.files,
    this.record,
    this.contact,
    this.location,
    this.seen = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    List<ChatImageModel> chatImages = [];
    List<ChatFileModel> chatFiles = [];
    if (json['image'] != null) {
      json['image'].forEach((image) {
        chatImages.add(ChatImageModel.fromJson(image));
      });
    }
    if (json['file'] != null) {
      json['file'].forEach((fileJson) {
        chatFiles.add(ChatFileModel.fromJson(fileJson));
      });
    }
    return MessageModel(
      virtualId: json['virtualId'],
      messageId: json['messageId'],
      senderId: json['senderId'],
      senderImage: json['senderImage'],
      senderName: json['senderName'],
      type: json['type'],
      dateTime: json['dateTime'],
      text: json['text'],
      location: json['location'],
      images: chatImages,
      files: chatFiles,
      video: json['video'] != null
          ? VideoModel.fromFirebase(json['video'])
          : null,
      record: json['voice'] != null
          ? ChatRecordModel.fromJson(json['voice'])
          : null,
      contact: json['contact'] != null
          ? ContactModel.fromJson(json['contact'])
          : null,
      seen: json['seen'],
    );
  }

  Map<String, dynamic> toJson(String messageId, [bool? seen]) {
    List<Map<String, dynamic>> imagesUrl = [];
    List<Map<String, dynamic>> filesUrl = [];

    images?.forEach((imageModel) {
      imagesUrl.add(imageModel.toJson());
    });
    files?.forEach((fileModel) {
      filesUrl.add(fileModel.toJson());
    });
    return {
      'virtualId': virtualId,
      'senderId': HiveUtils.getUserData()!.id,
      'senderImage': HiveUtils.getUserData()!.image,
      'senderName': HiveUtils.getUserData()!.name,
      'type': type,
      'dateTime': Timestamp.now(),
      'text': text,
      'image': imagesUrl,
      'video': video?.toJson(),
      'voice': record?.toJson(),
      'contact': contact?.toJson(),
      'file': filesUrl,
      'location': location,
      'messageId': messageId,
      'seen': seen?? false,
    };
  }


  MessageModel copyWith({
    String? virtualId,
    int? senderId,
    String? senderImage,
    String? senderName,
    String? type,
    Timestamp? dateTime,
    String? text,
    String? messageId,
    List<ChatImageModel>? images,
    List<ChatFileModel>? files,
    VideoModel? video,
    ChatRecordModel? record,
    ContactModel? contact,
    String? location,
    bool? seen,
  }) => MessageModel(virtualId: virtualId ?? this.virtualId,
          type: type ?? this.type,
          dateTime: dateTime ?? this.dateTime,
          video: video ?? this.video,
          text: text ?? this.text,
          contact: contact ?? this.contact,
          seen: seen ?? this.seen,
          files: files ?? this.files,
          images: images ?? this.images,
          location: location ?? this.location,
          messageId: messageId ?? this.messageId,
          record: record ?? this.record,
          senderId: senderId ?? this.senderId,
          senderImage: senderImage ?? this.senderImage,
          senderName: senderName ?? this.senderName);
}

enum MessageType { text, image, file, video, voice, contact, link, location }
