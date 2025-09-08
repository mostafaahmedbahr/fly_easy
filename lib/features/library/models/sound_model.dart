import 'package:hive_flutter/hive_flutter.dart';

part 'sound_model.g.dart';

@HiveType(typeId: 2)
class SoundModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String soundTitle;
  @HiveField(2)
  final String soundUrl;

  SoundModel({
    required this.id,
    required this.soundTitle,
    required this.soundUrl,
  });

  factory SoundModel.fromJson(Map<String, dynamic> json) {
    return SoundModel(
        id: json['id'],
        soundTitle: json['file_name'],
        soundUrl: json['full_file_path']);
  }
}
