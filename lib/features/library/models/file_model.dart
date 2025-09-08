import 'package:hive/hive.dart';

part 'file_model.g.dart';

@HiveType(typeId: 4)
class FileModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String fileUrl;
  @HiveField(3)
  final String extension;
  @HiveField(4)
  final int isClosed;

  FileModel(
      {required this.id,
      required this.name,
      required this.fileUrl,
      required this.extension,
      required this.isClosed});

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
        id: json['id'],
        name: json['file_name'],
        fileUrl: json['full_file_path'],
        extension: json['file_extension'],
        isClosed: 0);
  }
}
