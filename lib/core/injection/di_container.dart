import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:new_fly_easy_new/core/cache_manager/custom_cache_manager.dart';
import 'package:new_fly_easy_new/core/download_manager/download_manager.dart';
import 'package:new_fly_easy_new/core/firebase_services/storage_services/base_storage_services.dart';
import 'package:new_fly_easy_new/core/firebase_services/storage_services/storage_services.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/notifications/local_notifications.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.instance;

class ServiceLocator {
  void init() {
    // Connectivity
    sl.registerLazySingleton<InternetStatus>(() => InternetStatus(sl()));
    sl.registerLazySingleton<Connectivity>(() => Connectivity());

    // Utils
    sl.registerLazySingleton<Uuid>(() => const Uuid());
    sl.registerLazySingleton<DownloadManager>(() => DownloadManager());
    sl.registerLazySingleton<LocalNotifications>(() => LocalNotifications());
    sl.registerLazySingleton<CustomCacheManager>(() => CustomCacheManager());
    sl.registerLazySingleton<BaseFirebaseStorageServices>(() => FirebaseStorageServices(),);
    sl.registerLazySingleton<AppRouter>(() => AppRouter(),);

    //Error Handling
    sl.registerLazySingleton<ErrorModel>(() => const ErrorModel());
  }
}
