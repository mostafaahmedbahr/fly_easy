import 'package:equatable/equatable.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';

class MediaModel extends Equatable {
  final String? imageUrl;
  final VideoModel? video;
  final String type;

  const MediaModel({
     this.video,
     this.imageUrl,
    required this.type,
  });

  @override
  List<Object?> get props => [imageUrl,video,type];
}
