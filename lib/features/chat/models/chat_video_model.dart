import 'dart:io';

import 'package:hive/hive.dart';

part 'chat_video_model.g.dart';

@HiveType(typeId: 3)
class VideoModel extends HiveObject {
  @HiveField(0)
  File? videoFile;
  @HiveField(1)
  String? videoUrl;
  @HiveField(2)
  String? videoVirtualId;
  @HiveField(3)
  int? id;

  VideoModel({
    this.videoUrl,
    this.videoFile,
    this.videoVirtualId,
    this.id,
  });


  /// ///////////// for firebase //////////////////////////////
  factory VideoModel.fromFirebase(Map<String, dynamic> json) {
    return VideoModel(
      videoUrl: json['videoUrl'],
      videoVirtualId: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoUrl': videoUrl,
      'id': videoVirtualId,
    };
  }

  /// //////////// for library api ///////////////////////////////
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(id: json['id'], videoUrl: json['full_file_path']);
  }
}
