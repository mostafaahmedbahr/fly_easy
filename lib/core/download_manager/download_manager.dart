import 'package:dio/dio.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class DownloadManager {
  final Dio _dio = Dio();

  Future<String> get localPath async {
    final Directory? directory;
    if(Platform.isAndroid){
      directory = await getDownloadsDirectory();
    }else{
      directory=await getApplicationDocumentsDirectory();
    }
    return directory!.path;
  }

  Future<File> localFile(String fileName) async {

    final path = await localPath;
    return File('$path/$fileName');
  }

  Future<File?> getFileLocally(String fileName) async {
    final file = await localFile(fileName);
    // Check if the file exists before returning
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  Future<File> downloadFile(String url, String fileName) async {
    final file = await localFile(fileName);
    try {
      await _dio.download(url, file.path,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ));
      return file;
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }

  Future<void> downloadImage(String url, String name,String id) async {
    bool isDownloaded = await isImageDownloaded(id);
    if (!isDownloaded) {

      final file = File(await getImagePath(id));
      await _dio.download(
        url,
        file.path,
      );
     await ImageGallerySaverPlus.saveImage(await file.readAsBytes(),name: name,quality: 100,isReturnImagePathOfIOS: Platform.isIOS);
    }
  }

  Future<bool> isImageDownloaded(String id)async {
    String imagePath=await getImagePath(id);
    return File(imagePath).existsSync();
  }

  Future<String> getImagePath(String id)async{
    String path = await localPath;
    return '$path/images/$id';
  }

  Future<String> getVideoPath(String id) async {
    String path = await localPath;
    return '$path/videos/$id.mp4';
  }

  Future<void> downloadVideo(String videoUrl, String id) async {
    bool isDownloaded = await isVideoDownloaded(id);
    if (!isDownloaded) {
      final file = File(await getVideoPath(id));
      await _dio.download(
        videoUrl,
        file.path,
      );
      await ImageGallerySaverPlus.saveFile(file.path,isReturnPathOfIOS: Platform.isIOS);
    }
  }

  Future<bool> isVideoDownloaded(String id) async {
    String videoPath=await getVideoPath(id);
    return File(videoPath).existsSync();
  }

  Future<String>downloadRecord(String recordUrl,String id)async{
    await downloadFile(
        recordUrl, 'records/${id}_record.m4a');
    final path = await getRecordsFilePath(id);
    return path;
  }
  Future<String> getRecordsFilePath(String recordId) async {
    String localePath = await localPath;
    String sdPath = "$localePath/records";
    var newDirectory = Directory(sdPath);
    if (!newDirectory.existsSync()) {
      newDirectory.createSync(recursive: true);
    }
    return "$sdPath/${recordId}_record.m4a";
  }

  bool isRecordFileDownloaded(String recordPath) {
    return File(recordPath).existsSync();
  }

}
