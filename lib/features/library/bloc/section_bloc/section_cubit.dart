import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:new_fly_easy_new/core/cache_manager/custom_cache_manager.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:new_fly_easy_new/features/library/models/file_model.dart';
import 'package:new_fly_easy_new/features/library/models/image_model.dart';
import 'package:new_fly_easy_new/features/library/models/sound_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'section_state.dart';

class SectionCubit extends Cubit<SectionState> {
  SectionCubit() : super(SectionInitial());

  static SectionCubit get(BuildContext context) =>
      BlocProvider.of<SectionCubit>(context);

  late int sectionId;
  static const _pageSize = 15;

  Future<void> getImages(
      PagingController<int, ImageModel> imagesPagingController,
      int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
          'section_id':sectionId,
          'type': 1,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.sectionFiles, query: queryParameters);
        if (response.statusCode == 200) {
          List<ImageModel> list = [];
          response.data['data'].forEach((image) {
            list.add(ImageModel.fromJson(image));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            imagesPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            imagesPagingController.appendPage(list, nextPageKey as int);
          }
          HiveUtils.cacheImages(list,sectionId);
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        imagesPagingController.error = errorMessage;
        emit(GetImagesError(errorMessage));
      }
    } else {
      var cachedImages = HiveUtils.getCachedImages(sectionId);
      if (cachedImages.isNotEmpty) {
        imagesPagingController.appendLastPage(cachedImages);
      } else {
        imagesPagingController.error = AppStrings.checkInternet;
        emit(GetImagesError(AppStrings.checkInternet));
      }
    }
  }

  Future<void> getVideos(
      PagingController<int, VideoModel> videosPagingController,
      int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
          'section_id':sectionId,
          'type': 2,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.sectionFiles, query: queryParameters);
        if (response.statusCode == 200) {
          List<VideoModel> list = [];
          response.data['data'].forEach((video) {
            list.add(VideoModel.fromJson(video));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            videosPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            videosPagingController.appendPage(list, nextPageKey as int);
          }
          HiveUtils.cacheVideos(list,sectionId);
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        videosPagingController.error = errorMessage;
        emit(GetVideosError(errorMessage));
      }
    } else {
      var cachedVideos = HiveUtils.getCachedVideos(sectionId);
      if (cachedVideos.isNotEmpty) {
        videosPagingController.appendLastPage(cachedVideos);
      } else {
        videosPagingController.error = AppStrings.checkInternet;
        emit(GetVideosError(AppStrings.checkInternet));
      }
    }
  }

  Future<void> getFiles(PagingController<int, FileModel> filesPagingController,
      int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
          'section_id':sectionId,
          'type': 4,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.sectionFiles, query: queryParameters);
        if (response.statusCode == 200) {
          List<FileModel> list = [];
          response.data['data'].forEach((file) {
            list.add(FileModel.fromJson(file));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            filesPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            filesPagingController.appendPage(list, nextPageKey as int);
          }
          HiveUtils.cacheFiles(list,sectionId);
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        filesPagingController.error = errorMessage;
        emit(GetFilesError(errorMessage));
      }
    } else {
      final cachedFiles = HiveUtils.getCachedFiles(sectionId);
      if (cachedFiles.isNotEmpty) {
        filesPagingController.appendLastPage(cachedFiles);
      } else {
        filesPagingController.error = AppStrings.checkInternet;
        emit(GetFilesError(AppStrings.checkInternet));
      }
    }
  }

  Future<void> getSounds(
      PagingController<int, SoundModel> soundsPagingController,
      int pageKey) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
          'section_id':sectionId,
          'type': 3,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.sectionFiles, query: queryParameters);
        if (response.statusCode == 200) {
          List<SoundModel> list = [];
          response.data['data'].forEach((file) {
            list.add(SoundModel.fromJson(file));
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            soundsPagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            soundsPagingController.appendPage(list, nextPageKey as int);
          }
          HiveUtils.cacheSounds(list,sectionId);
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        soundsPagingController.error = errorMessage;
        emit(GetSoundsError(errorMessage));
      }
    } else {
      final cachedSounds = HiveUtils.getCachedSounds(sectionId);
      if (cachedSounds.isNotEmpty) {
        soundsPagingController.appendLastPage(cachedSounds);
      } else {
        soundsPagingController.error = AppStrings.checkInternet;
        emit(GetSoundsError(AppStrings.checkInternet));
      }
    }
  }

  Future<FileInfo?> checkCachedFile(String url) async {
    var file = await sl<CustomCacheManager>().checkCachedFile(url);
    return file;
  }

  Future<File> cacheFile(String url) async {
    return await sl<CustomCacheManager>().cacheFile(url);
  }
}
