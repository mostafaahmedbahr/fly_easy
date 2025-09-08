part of 'add_channel_cubit.dart';

@immutable
abstract class AddChannelState {}

class AddCommunityInitial extends AddChannelState {}

class PickImageSuccess extends AddChannelState {}

class AddModerators extends AddChannelState {}

class AddGuests extends AddChannelState {}

class CreateChannelLoad extends AddChannelState {}

class CreateChannelSuccess extends AddChannelState {}

class CreateChannelError extends AddChannelState {
  final String error;

  CreateChannelError(this.error);
}

class GetChannelDetailsLoad extends AddChannelState {}

class GetChannelDetailsSuccess extends AddChannelState {}

class GetChannelDetailsError extends AddChannelState {
  final String error;

  GetChannelDetailsError(this.error);
}
