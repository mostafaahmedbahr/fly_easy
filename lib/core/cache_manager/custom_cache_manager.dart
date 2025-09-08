import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  late DefaultCacheManager _cacheManager;

  void initCacheManager() {
    _cacheManager = DefaultCacheManager();
  }

  Future<FileInfo?> checkCachedFile(String url) async {
    var file = await _cacheManager.getFileFromCache(url);
    return file;
  }

  Future<File> cacheFile(String url) async {
  return  _cacheManager.getSingleFile(url);
  }
}
