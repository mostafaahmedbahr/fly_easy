part of 'chat_media_cubit.dart';

@immutable
abstract class ChatMediaState {}

class ChatMediaInitial extends ChatMediaState {}

class SettingsErrorState extends ChatMediaState {
  final String error;
  SettingsErrorState(this.error);
}

class GetDetailsLoad extends ChatMediaState {}

class GetDetailsSuccess extends ChatMediaState {}

class GetDetailsError extends SettingsErrorState {
  GetDetailsError(super.error);
}

class GetMediaLoad extends ChatMediaState {}

class GetMediaSuccess extends ChatMediaState {}

class GetMediaError extends SettingsErrorState {

  GetMediaError(super.error);
}

class GetLinksLoad extends ChatMediaState {}

class GetLinksSuccess extends ChatMediaState {}

class GetLinksError extends SettingsErrorState {

  GetLinksError(super.error);
}

class GetFilesLoad extends ChatMediaState {}

class GetFilesSuccess extends ChatMediaState {}

class GetFilesError extends SettingsErrorState {
  GetFilesError(super.error);
}

class DownloadFileLoad extends ChatMediaState {}

class DownloadFileSuccess extends ChatMediaState {}

class DownloadFileError extends SettingsErrorState {
  DownloadFileError(super.error);
}

class LeaveTeamLoading extends ChatMediaState {}

class LeaveTeamSuccess extends ChatMediaState {}

class LeaveTeamError extends SettingsErrorState {

  LeaveTeamError(super.error);
}
