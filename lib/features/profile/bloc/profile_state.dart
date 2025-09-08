part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ErrorState extends ProfileState {
  final String error;

  ErrorState(this.error);
}

class GetMyChannelsLoad extends ProfileState {}

class GetMyChannelsSuccess extends ProfileState {}

class GetMyChannelsError extends ErrorState {
  GetMyChannelsError(super.error);
}

class LogoutLoad extends ProfileState {}

class LogoutSuccess extends ProfileState {}

class LogoutError extends ErrorState {
  LogoutError(super.error);
}

class RefreshUserData extends ProfileState {}

class PickImagesSuccess extends ProfileState {}

class UpdateImageLoad extends ProfileState {}

class UpdateImageSuccess extends ProfileState {}

class UpdateImageError extends ProfileState {
  final String error;

  UpdateImageError(this.error);
}

class DeleteAccountLoad extends ProfileState {}

class DeleteAccountSuccess extends ProfileState {}
class DeleteAccountError extends ErrorState {
  DeleteAccountError(super.error);
}

