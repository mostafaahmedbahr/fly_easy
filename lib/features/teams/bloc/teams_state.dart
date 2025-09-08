part of 'teams_cubit.dart';

abstract class TeamsState {}

class TeamsInitial extends TeamsState {}

class ErrorState extends TeamsState {
  final String error;

  ErrorState(this.error);
}

class GetAdminChannelsLoad extends TeamsState {}

class GetAdminChannelsSuccess extends TeamsState {}

class GetAdminChannelsError extends ErrorState {
  GetAdminChannelsError(super.error);
}

class GetArchivedTeamsLoad extends TeamsState {}

class GetArchivedTeamsSuccess extends TeamsState {}

class GetArchivedTeamsError extends ErrorState {
  GetArchivedTeamsError(super.error);
}

class GetGuestChannelsLoad extends TeamsState {}

class GetGuestChannelsSuccess extends TeamsState {}

class GetGuestChannelsError extends ErrorState {
  GetGuestChannelsError(super.error);
}

class DeleteTeamLoad extends TeamsState {}

class DeleteTeamSuccess extends TeamsState {
  final int channelId;

  DeleteTeamSuccess(this.channelId);
}

class DeleteCommunitySuccess extends TeamsState {
  final int teamId, communityId;

  DeleteCommunitySuccess(this.teamId, this.communityId);
}

class DeleteSubCommunitySuccess extends TeamsState {
  final int teamId, communityId, subCommunityId;

  DeleteSubCommunitySuccess(this.teamId, this.communityId, this.subCommunityId);
}

class DeleteChannelError extends ErrorState {
  DeleteChannelError(super.error);
}

class AddToArchiveLoad extends TeamsState {}

class AddToArchiveSuccess extends TeamsState {
  final int channelId;

  AddToArchiveSuccess(this.channelId);
}

class AddToArchiveError extends ErrorState {
  AddToArchiveError(super.error);
}

class DeleteArchiveLoad extends TeamsState {}

class DeleteArchiveSuccess extends TeamsState {
  final int channelId;

  DeleteArchiveSuccess(this.channelId);
}

class DeleteArchiveError extends ErrorState {
  DeleteArchiveError(super.error);
}

class DuplicateChannelLoad extends TeamsState {}

class DuplicateChannelSuccess extends TeamsState {}

class DuplicateChannelError extends ErrorState {
  DuplicateChannelError(super.error);
}
