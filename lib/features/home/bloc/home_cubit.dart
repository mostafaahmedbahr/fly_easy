import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> getChatsNew(int pageKey,
      PagingController<int, UserChatModel> pagingController) async {
    if (await sl<InternetStatus>().checkConnectivity()) {
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.recentChats, query: queryParameters);
        if (response.statusCode == 200) {
          List<UserChatModel> list = [];
          response.data['data'].forEach((chat) {
            list.add(UserChatModel.fromJson(chat));
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
    }else{
      String errorMessage = LocaleKeys.check_internet.tr();
      pagingController.error = errorMessage;
    }
  }

  Future<void> deleteChat(int chatId) async {
    emit(DeleteChatLoad());
    try {
      final response = await DioHelper.postData(
          path: '${EndPoints.deleteRecentChat}/$chatId');
      if (response.statusCode == 200) {
        emit(DeleteChatSuccess(chatId));
      }
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
      final response =
      await DioHelper.getData(path: EndPoints.notificationsCount);
      if (response.statusCode == 200) {
        notificationsCount = response.data['counter'];
        emit(GetNotificationsCount(notificationsCount));
      }
    } catch (_) {}
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
}
