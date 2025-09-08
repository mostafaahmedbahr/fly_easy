import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/download_manager/download_manager.dart';
import 'package:new_fly_easy_new/core/firebase_services/firebase_keys.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_file_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat_media/models/media_model.dart';
import 'package:open_file/open_file.dart';

part 'user_chat_media_state.dart';

class UserChatMediaCubit extends Cubit<UserChatMediaState> {
  UserChatMediaCubit() : super(UserChatMediaInitial());

  static UserChatMediaCubit get(BuildContext context) =>
      BlocProvider.of<UserChatMediaCubit>(context);

  int? userId;
  List<MediaModel> mediaList = [];

  Future<void> getMedia() async {
    try {
      emit(GetMediaLoad());
      final media = await FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId.toString())
          .collection(FirebaseKeys.media)
          .get();
      for (var element in media.docs) {
        if (element['type'] == MessageType.image.name) {
          element['image'].forEach((image) {
            mediaList
                .add(MediaModel(type: MessageType.image.name, imageUrl: image['url']));
          });
        } else {
          mediaList.add(MediaModel(
              type: MessageType.video.name,
              video: VideoModel.fromFirebase(element['video'])));
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
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId.toString())
          .collection(FirebaseKeys.links)
          .get();
      for (var message in linksDocs.docs) {
        links.add(message['text']);
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
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId.toString())
          .collection(FirebaseKeys.files)
          .get();
      for (var message in filesDocs.docs) {
        message['file'].forEach((file) {
          files.add(ChatFileModel.fromJson(file));
        });
      }
      emit(GetFilesSuccess());
    } catch (error) {
      emit(GetFilesError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> openFile({required int index}) async {
    File? localFile = await fileManager
        .getFileLocally(getFileName(id: files[index].virtualId!, fileName: files[index].fileName!));
    if (localFile != null) {
      OpenFile.open(localFile.path);
    } else {
      await downloadFile(fileId: files[index].virtualId!, fileName: files[index].fileName!, fileUrl: files[index].fileUrl!);
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
}
