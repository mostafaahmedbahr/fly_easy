import 'package:new_fly_easy_new/core/hive/hive_keys.dart';
import 'package:hive/hive.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/library/models/file_model.dart';
import 'package:new_fly_easy_new/features/library/models/image_model.dart';
import 'package:new_fly_easy_new/features/library/models/section_model.dart';
import 'package:new_fly_easy_new/features/library/models/sound_model.dart';
import 'package:new_fly_easy_new/features/register/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveUtils {
  static Future<void> setUserData(UserModel userData) async {
    Hive.box<UserModel>(HiveKeys.userBox).put(HiveKeys.userKey, userData);
  }

  static UserModel? getUserData() {
    return Hive.box<UserModel>(HiveKeys.userBox).get(HiveKeys.userKey);
  }

  static Future<void> deleteUserData() async {
    await Hive.box<UserModel>(HiveKeys.userBox).delete(HiveKeys.userKey);
  }

  static bool hasMoreTeams() {
    return getUserData()!.remainsTeamsCount > 0;
  }

  static bool hasMoreCommunities() {
    return getUserData()!.remainsCommunitiesCount > 0;
  }

  static bool hasMoreSubCommunities() {
    return getUserData()!.remainsSubCommunitiesCount > 0;
  }

  static bool hasMoreMembers() {
    return getUserData()!.remainsMembersCount > 0;
  }

  static Future<void> cacheSections(List<SectionModel> sections) async {
    for (var section in sections) {
      Hive.box<SectionModel>(HiveKeys.sectionsBox).put(section.id, section);
    }
  }

  static Future<void> cacheImages(List<ImageModel> images, int sectionId) async {
    Map<int, ImageModel> newImages = {};
    for (var image in images) {
      newImages.addAll({image.id: image});
    }
    final isSectionExist= Hive.box<Map<dynamic, dynamic>?>(HiveKeys.imagesBox).containsKey(sectionId);
    if(isSectionExist){
      final cachedImages=Hive.box<Map<dynamic, dynamic>?>(HiveKeys.imagesBox).toMap()[sectionId];
      cachedImages!.addAll(newImages);
    }else{
         Hive.box<Map<dynamic, dynamic>?>(HiveKeys.imagesBox)
           .put(sectionId, newImages);
    }
  }

  static Future<void> cacheVideos(List<VideoModel> videos, int sectionId) async {
    Map<int, VideoModel> newVideos = {};
    for (var video in videos) {
      newVideos.addAll({video.id!: video});
    }
    final isSectionExist= Hive.box<Map<dynamic, dynamic>?>(HiveKeys.videosBox).containsKey(sectionId);
    if(isSectionExist){
      final cachedVideos=Hive.box<Map<dynamic, dynamic>?>(HiveKeys.videosBox).get(sectionId);
      cachedVideos!.addAll(newVideos);
    }else{
      Hive.box<Map<dynamic, dynamic>?>(HiveKeys.videosBox)
          .put(sectionId, newVideos);
    }
  }

  static Future<void> cacheFiles(List<FileModel> files, int sectionId) async {
    Map<int, FileModel> newFiles = {};
    for (var file in files) {
      newFiles.addAll({file.id: file});
    }
    final isSectionExist= Hive.box<Map<dynamic, dynamic>?>(HiveKeys.filesBox).containsKey(sectionId);
    if(isSectionExist){
      final cachedFiles=Hive.box<Map<dynamic, dynamic>?>(HiveKeys.filesBox).get(sectionId);
      cachedFiles!.addAll(newFiles);
    }else{
      Hive.box<Map<dynamic, dynamic>?>(HiveKeys.filesBox)
          .put(sectionId, newFiles);
    }
  }

  static Future<void> cacheSounds(List<SoundModel> sounds, int sectionId) async {
    Map<int, SoundModel> newSounds = {};
    for (var sound in sounds) {
      newSounds.addAll({sound.id: sound});
    }
    final isSectionExist= Hive.box<Map<dynamic, dynamic>?>(HiveKeys.soundsBox).containsKey(sectionId);
    if(isSectionExist){
      final cachedSounds=Hive.box<Map<dynamic, dynamic>?>(HiveKeys.soundsBox).get(sectionId);
      cachedSounds!.addAll(newSounds);
    }else{
      Hive.box<Map<dynamic, dynamic>?>(HiveKeys.soundsBox)
          .put(sectionId, newSounds);
    }
  }

  static List<SectionModel> getCachedSections() {
    return Hive.box<SectionModel>(HiveKeys.sectionsBox).values.toList();
  }

  static List<ImageModel> getCachedImages(int sectionId) {
    List<ImageModel> images = [];
    Map<dynamic, dynamic>? cachedImages =
        Hive.box<Map<dynamic, dynamic>?>(HiveKeys.imagesBox).get(sectionId);
    if (cachedImages != null) {
      for (var key in cachedImages.keys) {
        images.add(cachedImages[key]!);
      }
    }
    return images;
  }

  static List<VideoModel> getCachedVideos(int sectionId) {
    List<VideoModel> videos = [];
    Map<dynamic, dynamic>? cachedVideos =
        Hive.box<Map<dynamic, dynamic>?>(HiveKeys.videosBox).get(sectionId);
    if (cachedVideos != null) {
      for (var key in cachedVideos.keys) {
        videos.add(cachedVideos[key]!);
      }
    }
    return videos;
  }

  static List<SoundModel> getCachedSounds(int sectionId) {
    List<SoundModel> sounds = [];
    Map<dynamic, dynamic>? cachedSounds =
        Hive.box<Map<dynamic, dynamic>?>(HiveKeys.soundsBox).get(sectionId);
    if (cachedSounds != null) {
      for (var key in cachedSounds.keys) {
        sounds.add(cachedSounds[key]!);
      }
    }
    return sounds;
  }

  static List<FileModel> getCachedFiles(int sectionId) {
    List<FileModel> files = [];
    Map<dynamic, dynamic>? cachedFiles =
        Hive.box<Map<dynamic, dynamic>?>(HiveKeys.filesBox).get(sectionId);
    if (cachedFiles != null) {
      for (var key in cachedFiles.keys) {
        files.add(cachedFiles[key]!);
      }
    }
    return files;
  }

  static Future<void>_deleteCachedSections()async{
    await Hive.box<SectionModel>(HiveKeys.sectionsBox).clear();
  }

  static Future<void>_deleteCachedImages()async{
    await Hive.box<Map<dynamic, dynamic>?>(HiveKeys.imagesBox).clear();
  }

  static Future<void>_deleteCachedVideos()async{
    await Hive.box<Map<dynamic, dynamic>?>(HiveKeys.videosBox).clear();
  }

  static Future<void>_deleteCachedSounds()async{
    await Hive.box<Map<dynamic, dynamic>?>(HiveKeys.soundsBox).clear();
  }

  static Future<void>_deleteCachedFiles()async{
    await Hive.box<Map<dynamic, dynamic>?>(HiveKeys.filesBox).clear();
  }

  static Future<void>deleteLibraryCache()async{
    _deleteCachedImages();
    _deleteCachedVideos();
    _deleteCachedSounds();
    _deleteCachedFiles();
    _deleteCachedSections();
  }
}
