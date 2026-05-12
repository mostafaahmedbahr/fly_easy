import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/cache/cache_helper.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/features/home/firebase_user_model.dart';
import 'package:new_fly_easy_new/features/home/models/user_chat_model.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/home_banners_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(BuildContext context) =>
      BlocProvider.of<HomeCubit>(context);

  List<FirebaseUserModel> userChats = [];

  Future<void> getChats() async {
    userChats.clear();
    try {
      emit(GetChatsLoad());
      final chats = await FirebaseFirestore.instance
          .collection('users')
          .doc('${HiveUtils.getUserData()!.id}')
          .collection('chat')
          .get();
      for (var element in chats.docs) {
        // final lastMessage=chats.docs.last;
        userChats.add(FirebaseUserModel.fromJson(element.data()));
      }
      emit(GetChatsSuccess());
    } catch (error) {
      emit(GetChatsError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  static const _pageSize = 15;

  Future<void> getChatsNew(
      int pageKey,
      PagingController<int, UserChatModel> pagingController,
      ) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {'page': pageKey};
        final Response response = await DioHelper.getData(
          path: EndPoints.recentChats,
          query: queryParameters,
        );
        if (response.statusCode == 200) {
          List<UserChatModel> list = [];
          response.data['data'].forEach((chat) {
            final chatModel = UserChatModel.fromJson(chat);

            // Check if this chat is deleted from local cache (user's list only)
            final deleteKey = 'deleted_chat_${chatModel.id}';
            final isDeleted = CacheHelper.getData(key: deleteKey) ?? false;

            // Only add non-deleted chats to the list
            if (!isDeleted) {
              list.add(chatModel);
            }
          });
          final isLastPage = response.data['data'].length < _pageSize;
          if (isLastPage) {
            pagingController.appendLastPage(list);
          } else {
            final num nextPageKey = pageKey + 1;
            pagingController.appendPage(list, nextPageKey as int);
          }
        }
      } catch (error) {
        String errorMessage = sl<ErrorModel>().getErrorMessage(error);
        pagingController.error = errorMessage;
        emit(GetChatsError(errorMessage));
      }
    } else {
      String errorMessage = LocaleKeys.check_internet.tr();
      pagingController.error = errorMessage;
    }
  }

  Future<void> deleteChat(int chatId) async {
    emit(DeleteChatLoad());
    try {
      // Save deletion status to local cache only (not delete from server)
      final deleteKey = 'deleted_chat_$chatId';
      await CacheHelper.putData(key: deleteKey, value: true);

      emit(DeleteChatSuccess(chatId));
    } catch (error) {
      emit(DeleteChatError(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  // Future<void>getNotificationsCount()async{
  //   try{
  //     final response=await DioHelper.getData(path: EndPoints.notificationsCount);
  //     if(response.statusCode==200){
  //       emit(GetNotificationsCount(response.data['counter']));
  //       print("asssssssssssss");
  //       print(response.data);
  //     }
  //   }catch(error){}
  // }

  // Future<void> resetNotificationsCounter() async {
  //   try {
  //     await DioHelper.postData(path: EndPoints.resetNotificationsCount);
  //   } catch (error) {}
  // }
  int notificationsCount = 0;

  /// ================= Notifications =================

  Future<void> getNotificationsCount() async {
    try {
      final response = await DioHelper.getData(
        path: EndPoints.notificationsCount,
      );
      if (kDebugMode) {
        print('🔔 Notifications API Response: ${response.data}');
        print('🔔 Status Code: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        notificationsCount = response.data['counter'];
        if (kDebugMode) print('🔔 Notifications Count: $notificationsCount');
        emit(GetNotificationsCount(notificationsCount));
      }
    } catch (e) {
      if (kDebugMode) print('🔔 Error getting notifications: $e');
    }
  }

  void increaseNotifications() {
    notificationsCount++;
    emit(GetNotificationsCount(notificationsCount));
  }

  Future<void> resetNotificationsCounter() async {
    try {
      await DioHelper.postData(path: EndPoints.resetNotificationsCount);
      notificationsCount = 0;
      emit(GetNotificationsCount(0));
    } catch (_) {}
  }

  BannersModel? bannersModel;
  Future<void> getHomeBanners() async {
    emit(GetHomeBannersLoadingState());

    try {
      final response = await DioHelper.getData(path: EndPoints.homeBanners);

      print(response.data); // للتأكد فقط

      bannersModel = BannersModel.fromJson(response.data);

      emit(GetHomeBannersSuccessState(bannersModel!));
    } catch (error) {
      emit(GetHomeBannersErrorState(sl<ErrorModel>().getErrorMessage(error)));
    }
  }

  int currentSliderIndex = 0;
  changeHomeSliderImages(index) {
    currentSliderIndex = index;
    emit(ChangeHomeSliderImageState());
  }
}
