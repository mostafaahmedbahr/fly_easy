// import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
// import 'package:new_fly_easy_new/core/injection/di_container.dart';
// import 'package:new_fly_easy_new/core/network/connection.dart';
// import 'package:new_fly_easy_new/core/network/error_model.dart';
// import 'package:new_fly_easy_new/core/utils/strings.dart';
// import 'package:new_fly_easy_new/features/chat/models/chat_file_model.dart';
// import 'package:new_fly_easy_new/features/chat/models/chat_image_model.dart';
// import 'package:new_fly_easy_new/features/chat/models/chat_record_model.dart';
// import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
// import 'package:new_fly_easy_new/features/chat/models/contact_model.dart';
// import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
//
// part 'user_chat_state.dart';
//
// class UserChatCubit extends Cubit<UserChatState> {
//   UserChatCubit() : super(UserChatInitial());
//
//   static UserChatCubit get(BuildContext context) =>
//       BlocProvider.of<UserChatCubit>(context);
//
//   String? userId;
//   List<MessageModel> messages = [];
//
//   Future<void> sendTextMessage(MessageModel textMessage) async {
//     try {
//       final doc = FirebaseFirestore.instance
//           .collection('users')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('chat')
//           .doc(userId)
//           .collection('messages')
//           .doc();
//       doc.set(textMessage.toJson(doc.id));
//       final otherDoc=FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('chat')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('messages')
//           .doc();
//       otherDoc.set(textMessage.toJson(doc.id));
//       messages.insert(0, textMessage);
//       if (textMessage.type == MessageType.link.name) {
//         saveTeamLinks(textMessage);
//       }
//       emit(SendMessage());
//     } catch (error) {}
//   }
//
//   final soundPlayer = AudioPlayer();
//
//   Future<void> _makeSound() async {
//     soundPlayer.play(AssetSource('sounds/message.mp3'));
//   }
//
//   bool isInitial = true;
//
//   Future<void> getNewMessage() async {
//     emit(GetMessagesLoad());
//     if (await sl<InternetStatus>().checkConnectivity()) {
//       try {
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc('${HiveUtils.getUserData()!.id}')
//             .collection('chat')
//             .doc(userId)
//             .collection('messages')
//             .orderBy('dateTime', descending: true)
//             .limit(10)
//             .snapshots()
//             .listen((event) {
//           for (var element in event.docChanges) {
//             switch (element.type) {
//               case DocumentChangeType.added:
//                 if (isInitial) {
//                   messages.add(MessageModel.fromJson(element.doc.data()!));
//                 } else {
//                   MessageModel message =
//                       MessageModel.fromJson(element.doc.data()!);
//                   if (message.senderId != HiveUtils.getUserData()!.id) {
//                     messages.insert(0, message);
//                     _makeSound();
//                   }
//                 }
//                 break;
//               default:
//                 // messages.insert(0, MessageModel.fromJson(element.doc.data()!));
//                 break;
//             }
//           }
//           emit(GetMessagesSuccess());
//           isInitial = false;
//         });
//       } catch (error) {
//         if (error is FirebaseException) {
//           emit(GetMessagesError(error.code));
//         } else if (error is SocketException) {
//           emit(GetMessagesError(AppStrings.checkInternet));
//         } else {
//           emit(GetMessagesError(AppStrings.errorMessage));
//         }
//       }
//     } else {
//       emit(GetMessagesError(AppStrings.checkInternet));
//     }
//   }
//
//   bool hasMoreMessages = true;
//
//   Future<void> loadMore() async {
//     if (hasMoreMessages) {
//       try {
//         emit(LoadMore());
//         var moreData = await FirebaseFirestore.instance
//             .collection('users')
//             .doc('${HiveUtils.getUserData()!.id}')
//             .collection('chat')
//             .doc(userId)
//             .collection('messages')
//             .orderBy('dateTime', descending: true)
//             .where('dateTime', isLessThan: messages.last.dateTime)
//             .limit(10)
//             .get();
//         if (moreData.docs.isNotEmpty) {
//           if (kDebugMode) {
//             print(moreData.docs);
//           }
//           for (var element in moreData.docs) {
//             messages.add(MessageModel.fromJson(element.data()));
//           }
//         } else {
//           hasMoreMessages = false;
//         }
//         emit(GetMessagesSuccess());
//       } catch (error) {
//         if (error is FirebaseException) {
//           emit(GetMessagesError(error.code));
//         } else if (error is SocketException) {
//           emit(GetMessagesError(AppStrings.checkInternet));
//         } else {
//           emit(GetMessagesError(AppStrings.errorMessage));
//         }
//       }
//     }
//   }
//
//   /// ///////////////// images //////////////////////
//   final ImagePicker picker = ImagePicker();
//
//   Future<void> pickImageFromCamera() async {
//     try {
//       var file = await picker.pickImage(
//         source: ImageSource.camera,
//       );
//       if (file != null) {
//         ChatImageModel imageModel =
//             ChatImageModel(file: File(file.path), virtualId: const Uuid().v1());
//         MessageModel message = MessageModel(
//           virtualId: const Uuid().v1(),
//           type: MessageType.image.name,
//           dateTime: Timestamp.now(),
//           images: [imageModel],
//         );
//         await uploadImages(message);
//       }
//     } catch (error) {}
//   }
//
//   Future<void> pickImagesFromGallery() async {
//     List<File> images = [];
//     List<ChatImageModel> imagesModel = [];
//     try {
//       List<XFile> pickedImages = await picker.pickMultiImage(imageQuality: 50);
//       for (var element in pickedImages) {
//         images.add(File(element.path));
//         imagesModel.add(ChatImageModel(
//             file: File(element.path), virtualId: const Uuid().v1()));
//       }
//       if (images.isNotEmpty) {
//         MessageModel message = MessageModel(
//             virtualId: const Uuid().v1(),
//             type: MessageType.image.name,
//             dateTime: Timestamp.now(),
//             senderId: HiveUtils.getUserData()!.id,
//             senderImage: HiveUtils.getUserData()!.image,
//             senderName: HiveUtils.getUserData()!.name,
//             images: imagesModel);
//         messages.insert(0, message);
//         emit(PickImages());
//         await uploadImages(message);
//       }
//     } catch (error) {}
//   }
//
//   Future<void> uploadImages(MessageModel message) async {
//     try {
//       for (var image in message.images!) {
//         final ref = FirebaseStorage.instance.ref().child(
//             'images/${Uri.file(image.file!.path).pathSegments.last}/');
//         final task = await ref.putFile(image.file!);
//         await task.ref.getDownloadURL().then((value) {
//           image.imageUrl = value;
//           messages
//               .firstWhere((element) => element.virtualId == message.virtualId)
//               .images!
//               .firstWhere((element) => element.virtualId == image.virtualId)
//               .imageUrl = value;
//           emit(UploadImageSuccess(image.virtualId!));
//         });
//       }
//       sendImageMessage(message);
//       saveTeamMedia(message);
//     } catch (error) {}
//   }
//
//   Future<void> sendImageMessage(MessageModel message) async {
//     try {
//       final doc = FirebaseFirestore.instance
//           .collection('users')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('chat')
//           .doc(userId)
//           .collection('messages')
//           .doc();
//       final otherDoc=FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('chat')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('messages')
//           .doc();
//       otherDoc.set(message.toJson(otherDoc.id));
//       doc.set(message.toJson(doc.id));
//     } catch (error) {}
//   }
//
//   /// /////////////////// Videos ////////////////////////////////////
//   Future<void> pickVideo() async {
//     File? video;
//     VideoModel videoModel;
//     try {
//       XFile? pickedVideo = await picker.pickVideo(
//           maxDuration: const Duration(minutes: 2), source: ImageSource.gallery);
//       if (pickedVideo != null) {
//         video = File(pickedVideo.path);
//         videoModel =
//             VideoModel(videoFile: video, videoVirtualId: const Uuid().v1());
//         MessageModel message = MessageModel(
//             virtualId: const Uuid().v1(),
//             type: MessageType.video.name,
//             dateTime: Timestamp.now(),
//             senderId: HiveUtils.getUserData()!.id,
//             senderImage: HiveUtils.getUserData()!.image,
//             senderName: HiveUtils.getUserData()!.name,
//             video: videoModel);
//         messages.insert(0, message);
//         emit(PickVideo());
//         await uploadVideo(message);
//       }
//     } catch (error) {}
//   }
//
//   Future<void> uploadVideo(MessageModel message) async {
//     try {
//       final ref = FirebaseStorage.instance.ref().child(
//           'videos/${Uri.file(message.video!.videoFile!.path).pathSegments.last}');
//       final task = await ref.putFile(message.video!.videoFile!);
//       await task.ref.getDownloadURL().then((value) {
//         message.video!.videoUrl = value;
//         messages
//             .firstWhere((element) => element.virtualId == message.virtualId)
//             .video!
//             .videoUrl = value;
//         emit(UploadVideoSuccess(message.video!.videoVirtualId!));
//       });
//       sendImageMessage(message);
//       saveTeamMedia(message);
//     } catch (error) {}
//   }
//
//   /// /////////////////// Files //////////////////////////////////////
//   Future<void> pickFiles() async {
//     List<File> files = [];
//     List<ChatFileModel> filesModel = [];
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       type: FileType.any,
//       allowCompression: true,
//     );
//     if (result != null) {
//       for (var pickedFile in result.files) {
//         final fileId = const Uuid().v1();
//         final newFile = File(pickedFile.path!);
//
//         /// add this file to my download directory //////
//         final Directory? appDocDir = await getDownloadsDirectory();
//         final File localFile = File(
//             '${appDocDir!.path}/${getFileName(id: fileId, fileName: pickedFile.name)}');
//
//         /// this is the download path
//         await newFile.copy(localFile.path);
//
//         /// save the uploaded file in the download path to avoid download it again
//         /// ///////////////////////////////////////////
//         files.add(newFile);
//         filesModel.add(ChatFileModel(
//           file: File(pickedFile.path!),
//           virtualId: fileId,
//           fileName: pickedFile.name,
//           fileSize: pickedFile.size,
//           fileExtension: pickedFile.extension,
//         ));
//       }
//       MessageModel message = MessageModel(
//           virtualId: const Uuid().v1(),
//           type: MessageType.file.name,
//           dateTime: Timestamp.now(),
//           senderId: HiveUtils.getUserData()!.id,
//           senderImage: HiveUtils.getUserData()!.image,
//           senderName: HiveUtils.getUserData()!.name,
//           files: filesModel);
//       messages.insert(0, message);
//       emit(PickFileSuccess());
//       await uploadFiles(message);
//     }
//   }
//
//   Future<void> uploadFiles(MessageModel message) async {
//     try {
//       for (var file in message.files!) {
//         final ref = FirebaseStorage.instance.ref().child(
//             'files/${Uri.file(file.file!.path).pathSegments.last}');
//         final task = await ref.putFile(file.file!);
//         await task.ref.getDownloadURL().then((value) {
//           file.fileUrl = value;
//           messages
//               .firstWhere((element) => element.virtualId == message.virtualId)
//               .files!
//               .firstWhere((element) => element.virtualId == file.virtualId)
//               .fileUrl = value;
//           emit(UploadFileSuccess(file.virtualId!));
//         });
//       }
//       sendImageMessage(message);
//       saveTeamFiles(message);
//     } catch (error) {}
//   }
//
//   DownloadManager fileManager = DownloadManager();
//
//   Future<void> openChatFile(
//       {required String fileName,
//       required String fileId,
//       required String fileUrl}) async {
//     try {
//       // Check if file exists locally
//       File? localFile = await fileManager
//           .getFileLocally(getFileName(id: fileId, fileName: fileName));
//       if (localFile != null) {
//         OpenFile.open(localFile.path);
//       } else {
//         emit(DownloadFileLoad(fileId));
//         final file = await fileManager.downloadFile(
//             fileUrl, getFileName(id: fileId, fileName: fileName));
//         emit(DownloadFileSuccess(fileId));
//         OpenFile.open(file.path);
//       }
//     } catch (error) {
//       emit(DownloadFileError(fileId, sl<ErrorModel>().getErrorMessage(error)));
//     }
//   }
//
//   String getFileName({required String id, required String fileName}) {
//     return '${id}_$fileName';
//   }
//
//   Future<bool> isFileExist(String fileName) async {
//     return (await fileManager.getFileLocally(fileName) != null);
//   }
//
//   String getFileSize(int size) {
//     int length = size.toString().length;
//     if (length <= 6) {
//       return '${(size ~/ 1000).toString()} KB';
//     } else if (length == 7) {
//       return '${(size ~/ 10000).toString()} MB';
//     } else if (length == 8) {
//       return '${(size ~/ 100000).toString()} MB';
//     } else {
//       return '${(size ~/ 1000000).toString()} MB';
//     }
//   }
//
//   Widget getFileIcon(String extension, Color color) {
//     // You can add more cases for different file extensions
//     double size = 30;
//     switch (extension) {
//       case 'pdf':
//         return Icon(
//           Icons.picture_as_pdf,
//           color: color,
//           size: size,
//         );
//       case 'doc':
//       case 'docx':
//         return Icon(
//           Icons.description,
//           color: color,
//           size: size,
//         );
//       case 'xls':
//       case 'xlsx':
//         return Icon(
//           Icons.table_chart,
//           color: color,
//           size: size,
//         );
//       case 'jpg':
//       case 'png':
//       case 'jpeg':
//         return Icon(
//           Icons.image,
//           color: color,
//           size: size,
//         );
//       case 'mp4':
//       case 'avi':
//         return Icon(
//           Icons.movie,
//           color: color,
//           size: size,
//         );
//       case 'mp3':
//       case 'wav':
//         return Icon(
//           Icons.music_note,
//           color: color,
//         );
//       default:
//         return Icon(
//           Icons.insert_drive_file,
//           color: color,
//         );
//     }
//   }
//
//   /// //////////////// Record /////////////////////////////////////
//   Future<String> getRecordsFilePath(String recordId) async {
//     Directory? storageDirectory = await getDownloadsDirectory();
//     String sdPath = "${storageDirectory!.path}/records";
//     var newDirectory = Directory(sdPath);
//     if (!newDirectory.existsSync()) {
//       newDirectory.createSync(recursive: true);
//     }
//     return "$sdPath/${recordId}_record";
//   }
//
//   Future<void> saveAudioFile(String path, String recordId) async {
//     final audioFile = File(path);
//     final recordModel =
//         ChatRecordModel(virtualId: recordId, recordFile: audioFile);
//     MessageModel message = MessageModel(
//       virtualId: const Uuid().v1(),
//       type: MessageType.voice.name,
//       dateTime: Timestamp.now(),
//       senderId: HiveUtils.getUserData()!.id,
//       senderImage: HiveUtils.getUserData()!.image,
//       senderName: HiveUtils.getUserData()!.name,
//       record: recordModel,
//     );
//     messages.insert(0, message);
//     emit(SaveRecordSuccess());
//     await uploadRecord(message);
//   }
//
//   Future<void> uploadRecord(MessageModel message) async {
//     try {
//       final ref = FirebaseStorage.instance.ref().child(
//           'records/${Uri.file(message.record!.recordFile!.path).pathSegments.last}');
//       final task = await ref.putFile(message.record!.recordFile!);
//       await task.ref.getDownloadURL().then((value) async {
//         message.record!.recordUrl = value;
//         messages
//             .firstWhere((element) => element.virtualId == message.virtualId)
//             .record!
//             .recordUrl = value;
//         final path = await getRecordsFilePath(message.record!.virtualId!);
//         emit(UploadRecordSuccess(message.record!.virtualId!, path));
//       });
//       sendImageMessage(message);
//     } catch (error) {}
//   }
//
//   bool isRecordFileDownloaded(String recordPath) {
//     return File(recordPath).existsSync();
//   }
//
//   Future<void> downloadRecordFile(
//       {required String recordId, required String recordUrl}) async {
//     try {
//       emit(DownloadRecordLoad(recordId));
//       await fileManager.downloadFile(recordUrl, 'records/${recordId}_record');
//       final path = await getRecordsFilePath(recordId);
//       emit(DownloadRecordSuccess(recordId, path));
//     } catch (error) {
//       emit(DownloadRecordError(recordId,error.toString()));
//     }
//   }
//
//   /// to stop all other media ///
//   void playMedia(String id) {
//     emit(PlayMedia(id));
//   }
//
//   /// //////////////// Contacts ///////////////////////////////
//   void getSelectedContacts(List<Contact> selectedContacts) {
//     try {
//       List<ContactModel> contacts = [];
//       for (var contact in selectedContacts) {
//         contacts.add(ContactModel(
//             name: contact.displayName ?? '',
//             phone: contact.phones == null || contact.phones!.isEmpty
//                 ? ''
//                 : contact.phones![0].value!));
//       }
//       if (contacts.isNotEmpty) {
//         sendSelectedContacts(contacts);
//       }
//     } catch (error) {}
//   }
//
//   Future<void> sendSelectedContacts(List<ContactModel> contacts) async {
//     for (var contact in contacts) {
//       await sendTextMessage(MessageModel(
//           virtualId: const Uuid().v1(),
//           senderId: HiveUtils.getUserData()!.id,
//           senderName: HiveUtils.getUserData()!.name,
//           senderImage: HiveUtils.getUserData()!.image,
//           contact: contact,
//           type: MessageType.contact.name,
//           dateTime: Timestamp.now()));
//     }
//   }
//
//   /// ////////////////////////////////////////////////
//   /// ///////////// Save team media ///////////////////
//   /// /////////////////////////////////////////////////
//   Future<void> saveTeamMedia(MessageModel message) async {
//     try {
//       final doc = FirebaseFirestore.instance
//           .collection('users')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('chat')
//           .doc(userId)
//           .collection('media')
//           .doc();
//       final otherDoc=FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('chat')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('media')
//           .doc();
//        doc.set(message.toJson(doc.id));
//       otherDoc.set(message.toJson(otherDoc.id));
//     } catch (error) {}
//   }
//
//   Future<void> saveTeamFiles(MessageModel message) async {
//     try {
//       final doc = FirebaseFirestore.instance
//           .collection('users')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('chat')
//           .doc(userId)
//           .collection('files')
//           .doc();
//       final otherDoc=FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('chat')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('files')
//           .doc();
//       doc.set(message.toJson(doc.id));
//       otherDoc.set(message.toJson(otherDoc.id));
//     } catch (error) {}
//   }
//
//   Future<void> saveTeamLinks(MessageModel message) async {
//     try {
//       final doc = FirebaseFirestore.instance
//           .collection('users')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('chat')
//           .doc(userId)
//           .collection('links')
//           .doc();
//       final otherDoc=FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .collection('chat')
//           .doc('${HiveUtils.getUserData()!.id}')
//           .collection('links')
//           .doc();
//       doc.set(message.toJson(doc.id));
//       otherDoc.set(message.toJson(otherDoc.id));
//     } catch (error) {}
//   }
// }
