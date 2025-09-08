part of 'section_cubit.dart';

@immutable
abstract class SectionState {}

class SectionInitial extends SectionState {}

class ErrorState extends SectionState {
  final String error;

  ErrorState(this.error);
}

class GetImagesError extends ErrorState {
  GetImagesError(super.error);
}

class GetVideosError extends ErrorState {
  GetVideosError(super.error);
}

class GetFilesError extends ErrorState {
  GetFilesError(super.error);
}

class GetSoundsError extends ErrorState {
  GetSoundsError(super.error);
}
