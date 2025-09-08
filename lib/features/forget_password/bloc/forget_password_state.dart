part of 'forget_password_cubit.dart';

@immutable
abstract class ForgetPasswordState {}

class ErrorState extends ForgetPasswordState {
  final String error;
  ErrorState(this.error);
}

class ChangeCurrentView extends ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class SendEmailLoad extends ForgetPasswordState {}

class SendEmailSuccess extends ForgetPasswordState {}

class SendEmailError extends ErrorState {
  SendEmailError(super.error);
}

/// ///////////////// OTP View //////////////////////////////////

class ChangeActiveButton extends ForgetPasswordState {}

class SendOtpLoad extends ForgetPasswordState {}

class SendOtpSuccess extends ForgetPasswordState {}

class SendOtpError extends ErrorState {
  SendOtpError(super.error);
}

/// ///////////// Reset Pass View //////////////////////////////

class SendNewPassLoad extends ForgetPasswordState {}

class SendNewPassSuccess extends ForgetPasswordState {}

class SendNewPassError extends ErrorState {
  SendNewPassError(super.error);
}

