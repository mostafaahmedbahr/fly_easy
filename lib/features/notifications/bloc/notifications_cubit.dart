import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/network/connection.dart';
import 'package:new_fly_easy_new/core/network/dio_helper.dart';
import 'package:new_fly_easy_new/core/network/end_points.dart';
import 'package:new_fly_easy_new/core/network/error_model.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/features/notifications/model/notifications_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  static NotificationsCubit get(BuildContext context)=>BlocProvider.of<NotificationsCubit>(context);
  static const _pageSize = 15;

  Future<void>getNotifications(int pageKey,
      PagingController<int, NotificationModel> pagingController)async{
    if(await sl<InternetStatus>().checkConnectivity()){
      try {
        final Map<String, dynamic> queryParameters = {
          'page': pageKey,
        };
        final Response response = await DioHelper.getData(
            path: EndPoints.notifications, query: queryParameters);
        if (response.statusCode == 200) {
          List<NotificationModel> list = [];
          response.data['data'].forEach((notification) {
            list.add(NotificationModel.fromJson(notification));
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
        emit(GetNotificationError(errorMessage));
      }
    }else{
      emit(GetNotificationError(AppStrings.checkInternet));
    }
  }

  Future<void>deleteNotification(int id)async{
    try{
      await DioHelper.postData(path: '${EndPoints.deleteNotification}/$id');
    }catch(error){}
  }
}
