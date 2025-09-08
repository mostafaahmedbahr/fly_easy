import 'dart:io';

abstract class BaseFirebaseStorageServices {
  Future<String?>uploadImage(final File file);

  Future<String?>uploadVideo(final File file);

  Future<String?>uploadRecord(final File file);

  Future<String?>uploadFile(final File file);

}