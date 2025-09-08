part of 'invite_members_cubit.dart';

@immutable
abstract class InviteMembersState {}

class InviteMembersInitial extends InviteMembersState {}

class GetMembersError extends InviteMembersState {
  final String error;

  GetMembersError(this.error);
}
