part of 'app_cubit.dart';

@immutable
abstract class GlobalAppState {}

class ThemeInitial extends GlobalAppState {}

class ChangeMode extends GlobalAppState {}

class ChangeLanguage extends GlobalAppState {}

class RefreshUserImage extends GlobalAppState {}

class RefreshTeamsAfterAdd extends GlobalAppState {}

class RefreshTeamsAfterUpdate extends GlobalAppState {}

class RemoveTeamAfterLeave extends GlobalAppState {
  final int teamId;

  RemoveTeamAfterLeave(this.teamId);
}

class ReceiveTeamNotification extends GlobalAppState {
  final dynamic teamId;

  ReceiveTeamNotification(this.teamId);
}

class ReceiveUserNotification extends GlobalAppState {
  final dynamic userId;

  ReceiveUserNotification(this.userId);
}

class ClearTeamChatNotifications extends GlobalAppState {
  final dynamic teamId;

  ClearTeamChatNotifications(this.teamId);
}

class ClearUserChatNotifications extends GlobalAppState {
  final dynamic userId;

  ClearUserChatNotifications(this.userId);
}
class PermissionLoading extends GlobalAppState {}
class PermissionGranted extends GlobalAppState {}
class PermissionDenied extends GlobalAppState {}
class PermissionPermanentlyDenied extends GlobalAppState {}
class ContactsLoaded extends GlobalAppState {} // أضف هذا ال state الجديد