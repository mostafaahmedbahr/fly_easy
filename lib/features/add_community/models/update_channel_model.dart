import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:new_fly_easy_new/features/add_community/models/channel_details.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class UpdateChannelModel extends Equatable{
  final String name;
  final List<MemberModel> moderators;
  final List<MemberModel> guests;
  final XFile? image;
  final ChannelDetails currentChannel;

  const UpdateChannelModel({
    required this.name,
    required this.image,
    required this.guests,
    required this.moderators,
    required this.currentChannel,
  });

  Future<FormData> toJson() async {
    List<int> moderatorsId = [];
    List<int> guestsId = [];
    Map<String, dynamic> data = {};
    MultipartFile file;
    for (var moderator in moderators) {
      moderatorsId.add(moderator.id);
    }
    for (var guest in guests) {
      guestsId.add(guest.id);
    }
    if (moderatorsId.isNotEmpty) {
      data.addAll({'moderators[]': moderatorsId});
    }
    if (name != currentChannel.name) {
      data.addAll({'name': name});
    }
    if (guestsId.isNotEmpty) {
      data.addAll({'guests[]': guestsId});
    }
    if (image != null) {
      file = await MultipartFile.fromFile(
        image!.path,
        filename: image!.path.split('/').last,
        contentType: MediaType('image', 'jpeg'),
      );
      data.addAll({'logo': file});
    }
    FormData formData = FormData.fromMap(data);
    if (kDebugMode) {
      print(formData.fields);
      print(formData.files);
    }
    return FormData.fromMap(data);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name,moderators,guests,image,currentChannel];
}
