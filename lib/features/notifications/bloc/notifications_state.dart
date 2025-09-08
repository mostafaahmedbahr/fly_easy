part of 'notifications_cubit.dart';

@immutable
abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class GetNotificationError extends NotificationsState {
  final String error;

  GetNotificationError(this.error);
}

