import 'package:hive_flutter/hive_flutter.dart';

part 'image_model.g.dart';
@HiveType(typeId: 1)
class ImageModel extends HiveObject{
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String imageUrl;

   ImageModel({
     required this.id,
    required this.imageUrl
});

  factory ImageModel.fromJson(Map<String,dynamic>json){
    return  ImageModel(id: json['id'],imageUrl:json['full_file_path']);
  }

}