import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class CreateChannelModel extends Equatable{
  final String name;
  final int? parentId;
  final int level;
  final List<MemberModel> moderators;
  final List<MemberModel> guests;
  final XFile? image;

  const CreateChannelModel({
    required this.name,
    required this.level,
    required this.image,
    required this.guests,
    required this.moderators,
    this.parentId,
  });

  Future<FormData> toJson() async {
    Map<String, dynamic> data = {};
    List<int> currentGuestsId = [];
    List<int> currentModeratorsId = [];
    MultipartFile? file;
    for (var element in moderators) {
      currentModeratorsId.add(element.id);
    }
    for (var element in guests) {
      currentGuestsId.add(element.id);
    }
    if (image != null) {
      file = await MultipartFile.fromFile(
        image!.path,
        filename: image!.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      data.addAll({'logo': file});
    }
    if (parentId != null) {
      data.addAll({
        'parent_id': parentId.toString(),
      });
    }
    data.addAll({
      'name': name,
      'moderators[]': currentModeratorsId,
      'guests[]': currentGuestsId,
      'level': level,
    });
    FormData formData = FormData.fromMap(data);
    if (kDebugMode) {
      print(formData.files);
      print(formData.fields);
    }
    return formData;
  }

  @override
  List<Object?> get props => [name,parentId,level,moderators,guests,image];
}
