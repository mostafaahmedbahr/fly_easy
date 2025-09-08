part of 'user_chat_media_cubit.dart';

@immutable
abstract class UserChatMediaState {}

class UserChatMediaInitial extends UserChatMediaState {}

class GetMediaLoad extends UserChatMediaState {}

class GetMediaSuccess extends UserChatMediaState {}

class GetMediaError extends UserChatMediaState {
  final String error;

  GetMediaError(this.error);
}

class GetLinksLoad extends UserChatMediaState {}

class GetLinksSuccess extends UserChatMediaState {}

class GetLinksError extends UserChatMediaState {
  final String error;

  GetLinksError(this.error);
}

class GetFilesLoad extends UserChatMediaState {}

class GetFilesSuccess extends UserChatMediaState {}

class GetFilesError extends UserChatMediaState {
  final String error;

  GetFilesError(this.error);
}

class DownloadFileLoad extends UserChatMediaState {}

class DownloadFileSuccess extends UserChatMediaState {}

class DownloadFileError extends UserChatMediaState {
  final String error;

  DownloadFileError(this.error);
}
