part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetNotificationsCount extends HomeState {
  final int count;

  GetNotificationsCount(this.count);
}

class GetChatsLoad extends HomeState {}

class GetChatsSuccess extends HomeState {}

class GetChatsError extends HomeState {
  final String error;

  GetChatsError(this.error);
}

class DeleteChatLoad extends HomeState {}

class DeleteChatSuccess extends HomeState {
  final int chatId;

  DeleteChatSuccess(this.chatId);
}

class DeleteChatError extends HomeState {
  final String error;

  DeleteChatError(this.error);
}

class GetHomeBannersLoadingState extends HomeState{}
class GetHomeBannersSuccessState extends HomeState{
  final BannersModel bannersModel;
  GetHomeBannersSuccessState(this.bannersModel);

}
class GetHomeBannersErrorState extends HomeState{
  final String error;
  GetHomeBannersErrorState(this.error);
}

class ChangeHomeSliderImageState extends HomeState{}