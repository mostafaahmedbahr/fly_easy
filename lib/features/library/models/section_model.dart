import 'package:hive/hive.dart';
part 'section_model.g.dart';
@HiveType(typeId: 5)
class SectionModel extends HiveObject{
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool available;

  SectionModel({required this.id, required this.name, required this.available});

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
      id: json['id'],
      name: json['name'],
      available: json['available_for_authenticated']);
}
