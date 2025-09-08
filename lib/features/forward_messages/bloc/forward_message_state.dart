part of 'forward_message_cubit.dart';

@immutable
abstract class ForwardMessageState {}

class ForwardMessageInitial extends ForwardMessageState {}

class ErrorState extends ForwardMessageState {
  final String error;

  ErrorState(this.error);
}

class GetAvailableMembersLoad extends ForwardMessageState {}

class GetAvailableMembersSuccess extends ForwardMessageState {}

class GetAvailableMembersError extends ErrorState {
  GetAvailableMembersError(super.error);
}

class GetAvailableTeamsLoad extends ForwardMessageState {}

class GetAvailableTeamsSuccess extends ForwardMessageState {}

class GetAvailableTeamsError extends ErrorState {
  GetAvailableTeamsError(super.error);
}

class SelectMember extends ForwardMessageState {}

class UnSelectMember extends ForwardMessageState {}

class SelectAllMembers extends ForwardMessageState {
  final bool selected;

  SelectAllMembers(this.selected);
}

class SelectTeam extends ForwardMessageState {}

class UnSelectTeam extends ForwardMessageState {}

class SelectAllTeams extends ForwardMessageState {
  final bool selected;

  SelectAllTeams(this.selected);
}

class ForwardMessageLoad extends ForwardMessageState {}
