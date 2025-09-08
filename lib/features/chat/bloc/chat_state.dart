part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ErrorState extends ChatState {
  final String error;

  ErrorState(this.error);
}

class SendMessage extends ChatState {}

class GetMessagesLoad extends ChatState {}

class GetMessages extends ChatState {}

class UpdateMessageState extends ChatState {
  final String messageId;

  UpdateMessageState(this.messageId);
}

class GetMessagesError extends ChatState {
  final String error;

  GetMessagesError(this.error);
}

class LoadMore extends ChatState {}

class PickImages extends ChatState {}

class UploadImageSuccess extends ChatState {
  final String imageVirtualId;

  UploadImageSuccess(this.imageVirtualId);
}

class PickVideo extends ChatState {}

class UploadVideoSuccess extends ChatState {
  final String videoVirtualId;

  UploadVideoSuccess(this.videoVirtualId);
}

class PickFileSuccess extends ChatState {}

class UploadFileSuccess extends ChatState {
  final String virtualId;

  UploadFileSuccess(this.virtualId);
}

class DownloadFileLoad extends ChatState {
  final String fileId;

  DownloadFileLoad(this.fileId);
}

class DownloadFileSuccess extends ChatState {
  final String fileId;

  DownloadFileSuccess(this.fileId);
}

class DownloadFileError extends ChatState {
  final String fileId, error;

  DownloadFileError(this.fileId, this.error);
}

class SaveRecordSuccess extends ChatState {}

class UploadRecordSuccess extends ChatState {
  final String virtualId;
  final String recordPath;

  UploadRecordSuccess(this.virtualId, this.recordPath);
}

class DownloadRecordLoad extends ChatState {
  final String recordId;

  DownloadRecordLoad(this.recordId);
}

class DownloadRecordSuccess extends ChatState {
  final String recordId;
  final String recordPath;

  DownloadRecordSuccess(this.recordId, this.recordPath);
}

class DownloadRecordError extends ChatState {
  final String recordId;

  DownloadRecordError(this.recordId);
}

class PlayMedia extends ChatState {
  final String id;

  PlayMedia(this.id);
}

class GetPositionLoad extends ChatState {}

class GetPositionSuccess extends ChatState {}

class ShowLocationReasonMessage extends ChatState {}
