import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:new_fly_easy_new/core/firebase_services/storage_services/base_storage_services.dart';

class FirebaseStorageServices implements BaseFirebaseStorageServices {
  @override
  Future<String?> uploadFile(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('files/${Uri.file(file.path).pathSegments.last}');
    final task = await ref.putFile(file);
    await task.ref.getDownloadURL().then((value) {
      return value;
    }).catchError((onError) {
      throw onError;
    });
    return null;
  }

  @override
  Future<String?> uploadImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('images/${Uri.file(file.path).pathSegments.last}/');
    final task = await ref.putFile(file);
    await task.ref.getDownloadURL().then((value) {
      return value;
    }).catchError((onError) {
      throw onError;
    });
    return null;
  }

  @override
  Future<String?> uploadRecord(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('records/${Uri.file(file.path).pathSegments.last}');
    final task = await ref.putFile(file);
    await task.ref.getDownloadURL().then((value) {
      return value;
    }).catchError((onError) {
      throw onError;
    });
    return null;
  }

  @override
  Future<String?> uploadVideo(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('videos/${Uri.file(file.path).pathSegments.last}');
    final task = await ref.putFile(file);
    await task.ref.getDownloadURL().then((value) {
      return value;
    }).catchError((onError) {
      throw onError;
    });
    return null;
  }
}
