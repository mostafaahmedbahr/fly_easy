part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String userId;
  final String userName;

  LoginSuccess({required this.userId, required this.userName});
}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}

class EmailNotVerified extends LoginState {}
