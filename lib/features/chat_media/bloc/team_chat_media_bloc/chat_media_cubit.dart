import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:new_fly_easy_new/core/download_manager/download_manager.dart';
import 'package:new_fly_easy_new/core/firebase_services/firebase_keys.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/add_community/models/channel_details.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_file_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/chat_media/models/media_model.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:open_file/open_file.dart';

part 'chat_media_state.dart';

class ChatMediaCubit extends Cubit<ChatMediaState> {
  ChatMediaCubit() : super(ChatMediaInitial());

  static ChatMediaCubit get(BuildContext context) =>
      BlocProvider.of<ChatMediaCubit>(context);

  String? teamId;
  bool? isAdmin;

  List<MemberModel> moderators = [];
  List<MemberModel> members = [];
  ChannelDetails? channelDetails;

  Future<void> getChannelDetails() async {
    emit(GetDetailsLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final response = await DioHelper.getData(
            path: '${EndPoints.channelDetails}/$teamId');
        if (response.statusCode == 200) {
          channelDetails = ChannelDetails.fromJson(response.data['data']);
          _initializeDataForUpdate();
          emit(GetDetailsSuccess());
        }
      } catch (error) {
        emit(GetDetailsError(sl<ErrorModel>().getErrorMessage(error)));
      }
    } else {
      emit(GetDetailsError(AppStrings.checkInternet));
    }
  }

  void _initializeDataForUpdate() {
    moderators = channelDetails!.moderators;
    members = channelDetails!.guests;
  }

  List<MediaModel> mediaList = [];

  Future<void> getMedia() async {
    try {
      emit(GetMediaLoad());
      final media = await FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId)
          .collection(FirebaseKeys.media)
          .get();
      for (var element in media.docs) {
        if (element[FirebaseKeys.type] == MessageType.image.name) {
          element[FirebaseKeys.image].forEach((image) {
            mediaList
                .add(MediaModel(type: MessageType.image.name, imageUrl: image['url']));
          });
        } else {
          mediaList.add(MediaModel(
              type: MessageType.video.name,
              video: VideoModel.fromFirebase(element[FirebaseKeys.video])));
        }
      }
      emit(GetMediaSuccess());
    } catch (error) {
      emit(GetMediaError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  List<String> links = [];

  Future<void> getLinks() async {
    try {
      emit(GetLinksLoad());
      final linksDocs = await FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId)
          .collection(FirebaseKeys.links)
          .get();
      for (var message in linksDocs.docs) {
        links.add(message[FirebaseKeys.text]);
      }
      emit(GetLinksSuccess());
    } catch (error) {
      emit(GetLinksError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  List<ChatFileModel> files = [];

  Future<void> getFiles() async {
    try {
      emit(GetFilesLoad());
      final filesDocs = await FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId)
          .collection(FirebaseKeys.files)
          .get();
      for (var message in filesDocs.docs) {
        message[FirebaseKeys.file].forEach((file) {
          files.add(ChatFileModel.fromJson(file));
        });
      }
      emit(GetFilesSuccess());
    } catch (error) {
      emit(GetFilesError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> openFile({required int index}) async {
    File? localFile = await fileManager.getFileLocally(getFileName(
        id: files[index].virtualId!, fileName: files[index].fileName!));
    if (localFile != null) {
      OpenFile.open(localFile.path);
    } else {
      await downloadFile(
          fileId: files[index].virtualId!,
          fileName: files[index].fileName!,
          fileUrl: files[index].fileUrl!);
    }
  }

  DownloadManager fileManager = sl<DownloadManager>();

  Future<void> downloadFile(
      {required String fileId,
      required String fileName,
      required String fileUrl}) async {
    emit(DownloadFileLoad());
    try {
      final file = await fileManager.downloadFile(
          fileUrl, getFileName(id: fileId, fileName: fileName));
      emit(DownloadFileSuccess());
      OpenFile.open(file.path);
    } catch (error) {
      emit(DownloadFileError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  String getFileName({required String id, required String fileName}) {
    return '${id}_$fileName';
  }

  Widget getFileIcon(int index) {
    // You can add more cases for different file extensions
    switch (files[index].fileExtension) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description);
      case 'xls':
      case 'xlsx':
        return const Icon(Icons.table_chart);
      case 'jpg':
      case 'png':
      case 'jpeg':
        return const Icon(Icons.image);
      case 'mp4':
      case 'avi':
        return const Icon(Icons.movie);
      case 'mp3':
      case 'wav':
        return const Icon(Icons.music_note);
      default:
        return const Icon(Icons.insert_drive_file);
    }
  }

  String getFileSize(int size) {
    int length = size.toString().length;
    if (length <= 6) {
      return '${(size ~/ 1000).toString()} KB';
    } else if (length == 7) {
      return '${(size ~/ 10000).toString()} MB';
    } else if (length == 8) {
      return '${(size ~/ 100000).toString()} MB';
    } else {
      return '${(size ~/ 1000000).toString()} MB';
    }
  }

  Future<void> leaveTeam() async {
    emit(LeaveTeamLoading());
    try {
      final response = await DioHelper.postData(
          path: EndPoints.leaveChannel,
          data: FormData.fromMap({
            'channel_id': teamId,
            'members[]': [HiveUtils.getUserData()!.id],
          }));
      if (response.statusCode == 200) {
        emit(LeaveTeamSuccess());
      }
    } catch (error) {
      emit(LeaveTeamError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }
}
