import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service_plus/contacts_service_plus.dart';
// import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/download_manager/download_manager.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/firebase_services/firebase_keys.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_file_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_image_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_record_model.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/chat/models/contact_model.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(BuildContext context) =>
      BlocProvider.of<ChatCubit>(context);

  String? teamId;
  String? userId;
  final List<MessageModel> messages = [];
  AudioPlayer? soundPlayer;

  Future<void> _makeSound() async {
    soundPlayer!.play(AssetSource('sounds/message.mp3'));
  }

  // Clear all messages when opening a new chat
  void clearMessages() {
    messages.clear();
    if (chatStream != null) {
      chatStream!.cancel();
      chatStream = null;
    }
    isInitial = true;
  }

  // Leave team chat methods - Simple implementation
  Future<void> leaveTeamChat(int teamId) async {
    try {
      emit(LeaveChatLoad());
      // Just emit success for now - the UI will handle the read-only state
      emit(LeaveChatSuccess());
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  Future<void> leaveAndDeleteTeamChat(int teamId) async {
    try {
      emit(LeaveChatLoad());
      // Just emit success for now - navigation will handle removal
      emit(LeaveChatSuccess());
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  // Leave user chat methods - Simple implementation
  Future<void> leaveUserChat(int userId) async {
    try {
      emit(LeaveChatLoad());
      // Just emit success for now - the UI will handle the read-only state
      emit(LeaveChatSuccess());
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  Future<void> leaveAndDeleteUserChat(int userId) async {
    try {
      emit(LeaveChatLoad());
      // Just emit success for now - navigation will handle removal
      emit(LeaveChatSuccess());
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  // Check if user has left a team - Simple implementation
  Future<bool> hasUserLeftTeam(int teamId) async {
    // For now, always return false - leave status will be managed locally
    return false;
  }

  // Check if user has left a user chat - Simple implementation
  Future<bool> hasUserLeftChat(int userId) async {
    // For now, always return false - leave status will be managed locally
    return false;
  }

  // Create team with proper member management
  Future<void> createTeam({
    required String teamName,
    required String teamImage,
    required String description,
    required List<int> memberIds,
  }) async {
    try {
      emit(GetMessagesLoad());
      final currentUserId = HiveUtils.getUserData()!.id;

      // Create team document
      final teamRef = FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc();

      final teamData = {
        FirebaseKeys.teamId: teamRef.id,
        FirebaseKeys.teamName: teamName,
        FirebaseKeys.teamImage: teamImage,
        FirebaseKeys.description: description,
        FirebaseKeys.createdBy: currentUserId,
        FirebaseKeys.createdAt: DateTime.now().millisecondsSinceEpoch,
      };

      await teamRef.set(teamData);

      // Add creator as admin member
      await teamRef
          .collection(FirebaseKeys.members)
          .doc(currentUserId.toString())
          .set({
            FirebaseKeys.userId: currentUserId,
            FirebaseKeys.userName: HiveUtils.getUserData()!.name,
            FirebaseKeys.userImage: HiveUtils.getUserData()!.image,
            FirebaseKeys.role: 'admin',
            FirebaseKeys.joinedAt: DateTime.now().millisecondsSinceEpoch,
            FirebaseKeys.isActive: true,
            FirebaseKeys.hasLeft: false,
          });

      // Add other members
      for (var memberId in memberIds) {
        // TODO: Get user details for each member
        await teamRef
            .collection(FirebaseKeys.members)
            .doc(memberId.toString())
            .set({
              FirebaseKeys.userId: memberId,
              FirebaseKeys.userName: 'User $memberId', // TODO: Get actual name
              FirebaseKeys.userImage: '', // TODO: Get actual image
              FirebaseKeys.role: 'member',
              FirebaseKeys.joinedAt: DateTime.now().millisecondsSinceEpoch,
              FirebaseKeys.isActive: true,
              FirebaseKeys.hasLeft: false,
            });
      }

      // Add team to creator's teams list
      await FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(currentUserId.toString())
          .collection(FirebaseKeys.teams)
          .doc(teamRef.id)
          .set({
            FirebaseKeys.teamId: int.parse(teamRef.id),
            FirebaseKeys.teamName: teamName,
            FirebaseKeys.teamImage: teamImage,
            FirebaseKeys.joinedAt: DateTime.now().millisecondsSinceEpoch,
            FirebaseKeys.isActive: true,
            FirebaseKeys.hasLeft: false,
          });

      emit(GetMessages());
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  bool isInitial = true;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatStream;

  Future<void> getTeamMessages() async {
    emit(GetMessagesLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        chatStream = FirebaseFirestore.instance
            .collection(FirebaseKeys.teams)
            .doc(teamId)
            .collection(FirebaseKeys.chat)
            .orderBy('dateTime', descending: true)
            .limit(10)
            .snapshots()
            .listen((event) {
              for (var element in event.docChanges) {
                switch (element.type) {
                  case DocumentChangeType.added:
                    if (isInitial) {
                      messages.add(MessageModel.fromJson(element.doc.data()!));
                    } else {
                      MessageModel message = MessageModel.fromJson(
                        element.doc.data()!,
                      );
                      if (message.senderId != HiveUtils.getUserData()!.id) {
                        messages.insert(0, message);
                        _makeSound();
                      }
                    }
                    break;
                  default:
                    // messages.insert(0, MessageModel.fromJson(element.doc.data()!));
                    break;
                }
              }
              emit(GetMessages());
              isInitial = false;
            });
      } catch (error) {
        if (error is FirebaseException) {
          emit(GetMessagesError(error.code));
        } else if (error is SocketException) {
          emit(GetMessagesError(AppStrings.checkInternet));
        } else {
          emit(GetMessagesError(AppStrings.errorMessage));
        }
      }
    } else {
      emit(GetMessagesError(AppStrings.checkInternet));
    }
  }

  Future<void> getUserMessages() async {
    emit(GetMessagesLoad());
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        chatStream = FirebaseFirestore.instance
            .collection(FirebaseKeys.users)
            .doc('${HiveUtils.getUserData()!.id}')
            .collection(FirebaseKeys.chat)
            .doc(userId)
            .collection(FirebaseKeys.messages)
            .orderBy('dateTime', descending: true)
            .limit(10)
            .snapshots()
            .listen((event) {
              for (var element in event.docChanges) {
                switch (element.type) {
                  case DocumentChangeType.added:
                    MessageModel message = MessageModel.fromJson(
                      element.doc.data()!,
                    );
                    if (isInitial) {
                      messages.add(message);
                    } else {
                      if (message.senderId.toString() == userId) {
                        messages.insert(0, message);
                        _makeSound();
                      }
                    }
                    if (message.senderId.toString() == userId &&
                        !message.seen) {
                      markAsSeen(message.messageId!);
                    }
                    break;
                  case DocumentChangeType.modified:
                    emit(
                      UpdateMessageState(
                        element.doc.data()![FirebaseKeys.virtualId],
                      ),
                    );
                    messages
                            .firstWhere(
                              (message) => message.messageId == element.doc.id,
                            )
                            .seen =
                        true;
                  default:
                    break;
                }
              }
              emit(GetMessages());
              isInitial = false;
            });
      } catch (error) {
        if (error is FirebaseException) {
          emit(GetMessagesError(error.code));
        } else if (error is SocketException) {
          emit(GetMessagesError(AppStrings.checkInternet));
        } else {
          emit(GetMessagesError(AppStrings.errorMessage));
        }
      }
    } else {
      emit(GetMessagesError(AppStrings.checkInternet));
    }
  }

  Future<void> markAsSeen(String docId) async {
    try {
      FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(userId)
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.messages)
          .doc(docId)
          .update({FirebaseKeys.seen: true});
      FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId)
          .collection(FirebaseKeys.messages)
          .doc(docId)
          .update({FirebaseKeys.seen: true});
    } catch (error) {}
  }

  bool hasMoreMessages = true;

  Future<void> loadMoreMessages() async {
    if (teamId != null) {
      _loadMoreTeamMessages();
    } else {
      _loadMoreUserMessage();
    }
  }

  Future<void> _loadMoreTeamMessages() async {
    if (hasMoreMessages) {
      try {
        emit(LoadMore());
        var moreData = await FirebaseFirestore.instance
            .collection(FirebaseKeys.teams)
            .doc(teamId)
            .collection(FirebaseKeys.chat)
            .orderBy('dateTime', descending: true)
            .where('dateTime', isLessThan: messages.last.dateTime)
            .limit(10)
            .get();
        if (moreData.docs.isNotEmpty) {
          if (kDebugMode) {
            print(moreData.docs);
          }
          for (var element in moreData.docs) {
            messages.add(MessageModel.fromJson(element.data()));
          }
        } else {
          hasMoreMessages = false;
        }
        emit(GetMessages());
      } catch (error) {
        if (error is FirebaseException) {
          emit(GetMessagesError(error.code));
        } else if (error is SocketException) {
          emit(GetMessagesError(AppStrings.checkInternet));
        } else {
          emit(GetMessagesError(AppStrings.errorMessage));
        }
      }
    }
  }

  Future<void> _loadMoreUserMessage() async {
    if (hasMoreMessages) {
      try {
        emit(LoadMore());
        var moreData = await FirebaseFirestore.instance
            .collection(FirebaseKeys.users)
            .doc('${HiveUtils.getUserData()!.id}')
            .collection(FirebaseKeys.chat)
            .doc(userId)
            .collection(FirebaseKeys.messages)
            .orderBy('dateTime', descending: true)
            .where('dateTime', isLessThan: messages.last.dateTime)
            .limit(10)
            .get();
        if (moreData.docs.isNotEmpty) {
          if (kDebugMode) {
            print(moreData.docs);
          }
          for (var element in moreData.docs) {
            messages.add(MessageModel.fromJson(element.data()));
          }
        } else {
          hasMoreMessages = false;
        }
        emit(GetMessages());
      } catch (error) {
        if (error is FirebaseException) {
          emit(GetMessagesError(error.code));
        } else if (error is SocketException) {
          emit(GetMessagesError(AppStrings.checkInternet));
        } else {
          emit(GetMessagesError(AppStrings.errorMessage));
        }
      }
    }
  }

  /// ///////////////// images //////////////////////
  final ImagePicker picker = ImagePicker();

  Future<void> pickImageFromCamera() async {
    try {
      var file = await picker.pickImage(source: ImageSource.camera);
      if (file != null) {
        ChatImageModel imageModel = ChatImageModel(
          file: File(file.path),
          virtualId: sl<Uuid>().v1(),
        );
        MessageModel message = MessageModel(
          virtualId: sl<Uuid>().v1(),
          type: MessageType.image.name,
          dateTime: Timestamp.now(),
          images: [imageModel],
        );
        await uploadImages(message);
      }
    } catch (error) {
      emit(ErrorState(AppStrings.errorMessage));
    }
  }

  Future<void> pickImagesFromGallery() async {
    List<File> images = [];
    List<ChatImageModel> imagesModel = [];
    try {
      List<XFile> pickedImages = await picker.pickMultiImage(imageQuality: 50);
      for (var element in pickedImages) {
        images.add(File(element.path));
        imagesModel.add(
          ChatImageModel(
            file: File(element.path),
            virtualId: sl<Uuid>().v1(),
            name: element.name,
          ),
        );
      }
      if (images.isNotEmpty) {
        MessageModel message = MessageModel(
          virtualId: sl<Uuid>().v1(),
          type: MessageType.image.name,
          dateTime: Timestamp.now(),
          senderId: HiveUtils.getUserData()!.id,
          senderImage: HiveUtils.getUserData()!.image,
          senderName: HiveUtils.getUserData()!.name,
          images: imagesModel,
        );
        messages.insert(0, message);
        emit(PickImages());
        await uploadImages(message);
      }
    } catch (error) {
      emit(ErrorState(AppStrings.errorMessage));
    }
  }

  Future<void> uploadImages(MessageModel message) async {
    try {
      for (var image in message.images!) {
        final ref = FirebaseStorage.instance.ref().child(
          'images/${Uri.file(image.file!.path).pathSegments.last}/',
        );
        final task = await ref.putFile(image.file!);
        await task.ref.getDownloadURL().then((value) {
          image.imageUrl = value;
          messages
                  .firstWhere(
                    (element) => element.virtualId == message.virtualId,
                  )
                  .images!
                  .firstWhere((element) => element.virtualId == image.virtualId)
                  .imageUrl =
              value;
          emit(UploadImageSuccess(image.virtualId!));
        });
      }

      if (teamId != null) {
        sendTeamImageMessage(message);
        saveTeamMedia(message);
      } else {
        sendFileMessage(message);
        saveUsersMedia(message);
      }
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> sendTeamImageMessage(MessageModel message) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId.toString())
          .collection(FirebaseKeys.chat)
          .doc();
      await doc.set(message.toJson(doc.id));
      sendTeamNotification();
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  void downloadImages(List<ChatImageModel> images) {
    for (var image in images) {
      sl<DownloadManager>().downloadImage(
        image.imageUrl!,
        image.name ?? image.virtualId!,
        image.virtualId!,
      );
    }
  }

  /// /////////////////// Videos ////////////////////////////////////
  Future<void> pickVideo() async {
    File? video;
    VideoModel videoModel;
    try {
      XFile? pickedVideo = await picker.pickVideo(
        maxDuration: const Duration(minutes: 2),
        source: ImageSource.gallery,
      );
      if (pickedVideo != null) {
        video = File(pickedVideo.path);
        videoModel = VideoModel(
          videoFile: video,
          videoVirtualId: sl<Uuid>().v1(),
        );
        MessageModel message = MessageModel(
          virtualId: sl<Uuid>().v1(),
          type: MessageType.video.name,
          dateTime: Timestamp.now(),
          senderId: HiveUtils.getUserData()!.id,
          senderImage: HiveUtils.getUserData()!.image,
          senderName: HiveUtils.getUserData()!.name,
          video: videoModel,
        );
        messages.insert(0, message);
        emit(PickVideo());
        await uploadVideo(message);
      }
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> uploadVideo(MessageModel message) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
        'videos/${Uri.file(message.video!.videoFile!.path).pathSegments.last}',
      );
      final task = await ref.putFile(message.video!.videoFile!);
      await task.ref.getDownloadURL().then((value) {
        message.video!.videoUrl = value;
        messages
                .firstWhere((element) => element.virtualId == message.virtualId)
                .video!
                .videoUrl =
            value;
        emit(UploadVideoSuccess(message.video!.videoVirtualId!));
      });
      if (teamId != null) {
        sendTeamImageMessage(message);
        saveTeamMedia(message);
      } else {
        sendFileMessage(message);
        saveUsersMedia(message);
      }
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  /// /////////////////// Files //////////////////////////////////////
  Future<void> pickFiles() async {
    List<File> files = [];
    List<ChatFileModel> filesModel = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      allowCompression: true,
    );
    if (result != null) {
      for (var pickedFile in result.files) {
        final fileId = sl<Uuid>().v1();
        final newFile = File(pickedFile.path!);

        /// add this file to my download directory //////
        String localPath = await downloadManager.localPath;
        final File localFile = File(
          '$localPath/${getFileName(id: fileId, fileName: pickedFile.name)}',
        );

        /// this is the download path
        await newFile.copy(localFile.path);

        /// save the uploaded file in the download path to avoid download it again
        /// ///////////////////////////////////////////

        files.add(newFile);
        filesModel.add(
          ChatFileModel(
            file: File(pickedFile.path!),
            virtualId: fileId,
            fileName: pickedFile.name,
            fileSize: pickedFile.size,
            fileExtension: pickedFile.extension,
          ),
        );
      }
      MessageModel message = MessageModel(
        virtualId: sl<Uuid>().v1(),
        type: MessageType.file.name,
        dateTime: Timestamp.now(),
        senderId: HiveUtils.getUserData()!.id,
        senderImage: HiveUtils.getUserData()!.image,
        senderName: HiveUtils.getUserData()!.name,
        files: filesModel,
      );
      messages.insert(0, message);
      emit(PickFileSuccess());
      await uploadFiles(message);
    }
  }

  Future<void> uploadFiles(MessageModel message) async {
    try {
      for (var file in message.files!) {
        final ref = FirebaseStorage.instance.ref().child(
          'files/${Uri.file(file.file!.path).pathSegments.last}',
        );
        final task = await ref.putFile(file.file!);
        await task.ref.getDownloadURL().then((value) {
          file.fileUrl = value;
          messages
                  .firstWhere(
                    (element) => element.virtualId == message.virtualId,
                  )
                  .files!
                  .firstWhere((element) => element.virtualId == file.virtualId)
                  .fileUrl =
              value;
          emit(UploadFileSuccess(file.virtualId!));
        });
      }
      if (teamId != null) {
        sendTeamImageMessage(message);
        saveTeamFiles(message);
      } else {
        sendFileMessage(message);
        saveUsersFiles(message);
      }
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  DownloadManager downloadManager = sl<DownloadManager>();

  Future<void> openChatFile({
    required String fileName,
    required String fileId,
    required String fileUrl,
  }) async {
    try {
      // Check if file exists locally
      File? localFile = await downloadManager.getFileLocally(
        getFileName(id: fileId, fileName: fileName),
      );
      if (localFile != null) {
        OpenFile.open(localFile.path);
      } else {
        emit(DownloadFileLoad(fileId));
        final file = await downloadManager.downloadFile(
          fileUrl,
          getFileName(id: fileId, fileName: fileName),
        );
        emit(DownloadFileSuccess(fileId));
        OpenFile.open(file.path);
      }
    } catch (error) {
      emit(DownloadFileError(fileId, sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  String getFileName({required String id, required String fileName}) {
    return '${id}_$fileName';
  }

  Future<bool> isFileExist(String name, String id) async {
    String fileName = getFileName(id: id, fileName: name);
    return (await downloadManager.getFileLocally(fileName) != null);
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

  Widget getFileIcon(String extension, Color color) {
    // You can add more cases for different file extensions
    double size = 30;
    switch (extension) {
      case 'pdf':
        return Icon(Icons.picture_as_pdf, color: color, size: size);
      case 'doc':
      case 'docx':
        return Icon(Icons.description, color: color, size: size);
      case 'xls':
      case 'xlsx':
        return Icon(Icons.table_chart, color: color, size: size);
      case 'jpg':
      case 'png':
      case 'jpeg':
        return Icon(Icons.image, color: color, size: size);
      case 'mp4':
      case 'avi':
        return Icon(Icons.movie, color: color, size: size);
      case 'mp3':
      case 'wav':
        return Icon(Icons.music_note, color: color);
      default:
        return Icon(Icons.insert_drive_file, color: color);
    }
  }

  /// //////////////// Record /////////////////////////////////////
  Future<String> getRecordsFilePath(String recordId) async {
    String localPath = await downloadManager.localPath;
    String sdPath = "$localPath/records";
    var newDirectory = Directory(sdPath);
    if (!newDirectory.existsSync()) {
      newDirectory.createSync(recursive: true);
    }
    return "$sdPath/${recordId}_record.m4a";
  }

  Future<void> saveAudioFile(String path, String recordId) async {
    final audioFile = File(path);
    final recordModel = ChatRecordModel(
      virtualId: recordId,
      recordFile: audioFile,
    );
    MessageModel message = MessageModel(
      virtualId: sl<Uuid>().v1(),
      type: MessageType.voice.name,
      dateTime: Timestamp.now(),
      senderId: HiveUtils.getUserData()!.id,
      senderImage: HiveUtils.getUserData()!.image,
      senderName: HiveUtils.getUserData()!.name,
      record: recordModel,
    );
    messages.insert(0, message);
    emit(SaveRecordSuccess());
    await uploadRecord(message);
  }

  Future<void> uploadRecord(MessageModel message) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(
        'records/${Uri.file(message.record!.recordFile!.path).pathSegments.last}',
      );
      final task = await ref.putFile(message.record!.recordFile!);
      await task.ref.getDownloadURL().then((value) async {
        message.record!.recordUrl = value;
        messages
                .firstWhere((element) => element.virtualId == message.virtualId)
                .record!
                .recordUrl =
            value;
        final path = await getRecordsFilePath(message.record!.virtualId!);
        emit(UploadRecordSuccess(message.record!.virtualId!, path));
      });
      if (teamId != null) {
        sendTeamImageMessage(message);
      } else {
        sendFileMessage(message);
      }
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  bool isRecordFileDownloaded(String recordPath) {
    return File(recordPath).existsSync();
  }

  Future<void> downloadRecordFile({
    required String recordId,
    required String recordUrl,
  }) async {
    try {
      emit(DownloadRecordLoad(recordId));
      await downloadManager.downloadFile(
        recordUrl,
        'records/${recordId}_record.m4a',
      );
      final path = await getRecordsFilePath(recordId);
      emit(DownloadRecordSuccess(recordId, path));
    } catch (error) {
      emit(DownloadRecordError(error.toString()));
    }
  }

  /// to stop all other media ///
  void playMedia(String id) {
    emit(PlayMedia(id));
  }

  /// //////////////// Contacts ///////////////////////////////
  void getSelectedContacts(List<Contact> selectedContacts) {
    try {
      List<ContactModel> contacts = [];
      for (var contact in selectedContacts) {
        contacts.add(
          ContactModel(
            name: contact.displayName ?? '',
            phone: contact.phones == null || contact.phones!.isEmpty
                ? ''
                : contact.phones![0].value!,
          ),
        );
      }
      if (contacts.isNotEmpty) {
        sendSelectedContacts(contacts);
      }
    } catch (error) {
      emit(ErrorState(AppStrings.errorMessage));
    }
  }

  Future<void> sendSelectedContacts(List<ContactModel> contacts) async {
    for (var contact in contacts) {
      final message = MessageModel(
        virtualId: sl<Uuid>().v1(),
        senderId: HiveUtils.getUserData()!.id,
        senderName: HiveUtils.getUserData()!.name,
        senderImage: HiveUtils.getUserData()!.image,
        contact: contact,
        type: MessageType.contact.name,
        dateTime: Timestamp.now(),
      );
      if (teamId != null) {
        await sendTeamTextMessage(message);
      } else {
        await sendTextMessage(message);
      }
    }
  }

  /// ///////////// Location /////////////////////////////////////
  bool isLocationReasonAccepted = false;

  Future<void> showLocationReasonMessage() async {
    emit(ShowLocationReasonMessage());
  }

  Future<Position?> _accessLocation() async {
    bool serviceEnabled;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      if (!(await Geolocator.isLocationServiceEnabled())) {
        throw 'Location service is disabled';
      }
    }

    if (await checkLocationPermission()) {
      final position = await _determinePosition();
      return position;
    }
    return null;
  }

  Future<bool> checkLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await showLocationReasonMessage();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    } else if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }
    return true;
  }

  Future<Position> _determinePosition() async {
    emit(GetPositionLoad());
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    emit(GetPositionSuccess());
    return position;
  }

  Future<void> sendLocation() async {
    try {
      final String messageId = sl<Uuid>().v1();
      final Position? location = await _accessLocation();
      if (location != null) {
        final message = MessageModel(
          virtualId: messageId,
          senderId: HiveUtils.getUserData()!.id,
          senderName: HiveUtils.getUserData()!.name,
          senderImage: HiveUtils.getUserData()!.image,
          text:
              'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}',
          type: MessageType.location.name,
          dateTime: Timestamp.now(),
        );
        if (teamId != null) {
          await sendTeamTextMessage(message);
        } else {
          await sendTextMessage(message);
        }
      }
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  /// ////////////////////////////////////////////////
  /// ///////////// Save media ///////////////////
  /// /////////////////////////////////////////////////
  Future<void> saveTeamMedia(MessageModel message) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId.toString())
          .collection(FirebaseKeys.media)
          .doc();
      await doc.set(message.toJson(doc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> saveTeamFiles(MessageModel message) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId.toString())
          .collection(FirebaseKeys.files)
          .doc();
      await doc.set(message.toJson(doc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> saveTeamLinks(MessageModel message) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId.toString())
          .collection(FirebaseKeys.links)
          .doc();
      await doc.set(message.toJson(doc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  /// ///////////////////////////////////////////////////
  /// //////////// Users Chat ///////////////////////////
  /// ///////////////////////////////////////////////////
  bool chatExist = false;

  Future<void> createUsersChats(List<String> membersId) async {
    try {
      await DioHelper.postData(
        path: EndPoints.forwardMessage,
        data: FormData.fromMap({'who_receive_message[]': membersId}),
      );
      chatExist = true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendTeamTextMessage(MessageModel textMessage) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.teams)
          .doc(teamId)
          .collection(FirebaseKeys.chat)
          .doc();
      doc.set(textMessage.toJson(doc.id, false));
      sendTeamNotification();
      messages.insert(0, textMessage);
      if (textMessage.type == MessageType.link.name) {
        saveTeamLinks(textMessage);
      }
      emit(SendMessage());
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> sendTextMessage(MessageModel textMessage) async {
    try {
      if (!chatExist) {
        createUsersChats([userId!]);
      }
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId)
          .collection(FirebaseKeys.messages)
          .doc();
      doc.set(textMessage.toJson(doc.id, false));
      final otherDoc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(userId)
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.messages)
          .doc(doc.id);
      otherDoc.set(textMessage.toJson(doc.id, false));
      sendUserNotification();
      messages.insert(0, textMessage);
      if (textMessage.type == MessageType.link.name) {
        saveUsersLinks(textMessage);
      }
      emit(SendMessage());
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> sendFileMessage(MessageModel message) async {
    try {
      if (!chatExist) {
        createUsersChats([userId!]);
      }
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId)
          .collection(FirebaseKeys.messages)
          .doc();
      final otherDoc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(userId)
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.messages)
          .doc(doc.id);
      sendUserNotification();
      otherDoc.set(message.toJson(doc.id, false));
      doc.set(message.toJson(doc.id, false));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> saveUsersMedia(MessageModel message) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId)
          .collection(FirebaseKeys.media)
          .doc();
      final otherDoc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(userId)
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.media)
          .doc();
      doc.set(message.toJson(doc.id));
      otherDoc.set(message.toJson(otherDoc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> saveUsersFiles(MessageModel message) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId)
          .collection(FirebaseKeys.files)
          .doc();
      final otherDoc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(userId)
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.files)
          .doc();
      doc.set(message.toJson(doc.id));
      otherDoc.set(message.toJson(otherDoc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  Future<void> saveUsersLinks(MessageModel message) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.chat)
          .doc(userId)
          .collection(FirebaseKeys.links)
          .doc();
      final otherDoc = FirebaseFirestore.instance
          .collection(FirebaseKeys.users)
          .doc(userId)
          .collection(FirebaseKeys.chat)
          .doc('${HiveUtils.getUserData()!.id}')
          .collection(FirebaseKeys.links)
          .doc();
      doc.set(message.toJson(doc.id));
      otherDoc.set(message.toJson(otherDoc.id));
    } catch (error) {
      emit(ErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  /// //////////////////////////////////////////////////////
  /// /////////////// Notifications /////////////////////////
  /// //////////////////////////////////////////////////////

  Future<void> sendUserNotification() async {
    try {
      await DioHelper.postData(
        path: EndPoints.sendUserNotification,
        data: FormData.fromMap({
          'from': HiveUtils.getUserData()!.id,
          'user_ids[]': [userId],
        }),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> sendTeamNotification() async {
    try {
      DioHelper.postData(
        path: '${EndPoints.sendTeamNotification}/$teamId',
        data: FormData.fromMap({'from': HiveUtils.getUserData()!.id}),
      );
    } catch (error) {
      rethrow;
    }
  }
}
