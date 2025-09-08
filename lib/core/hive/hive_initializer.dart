import 'package:new_fly_easy_new/core/hive/hive_keys.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/library/models/file_model.dart';
import 'package:new_fly_easy_new/features/library/models/image_model.dart';
import 'package:new_fly_easy_new/features/library/models/section_model.dart';
import 'package:new_fly_easy_new/features/library/models/sound_model.dart';
import 'package:new_fly_easy_new/features/register/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveInitializer {
  static Future<void> initializeHive() async {
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ImageModelAdapter());
    Hive.registerAdapter(VideoModelAdapter());
    Hive.registerAdapter(FileModelAdapter());
    Hive.registerAdapter(SoundModelAdapter());
    Hive.registerAdapter(SectionModelAdapter());
    await Hive.openBox<UserModel>(HiveKeys.userBox);
    await Hive.openBox<Map<dynamic,dynamic>?>(HiveKeys.imagesBox);
    await Hive.openBox<Map<dynamic,dynamic>?>(HiveKeys.videosBox);
    await Hive.openBox<Map<dynamic,dynamic>?>(HiveKeys.filesBox);
    await Hive.openBox<Map<dynamic,dynamic>?>(HiveKeys.soundsBox);
    await Hive.openBox<SectionModel>(HiveKeys.sectionsBox);
  }
}
