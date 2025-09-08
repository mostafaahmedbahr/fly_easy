part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class ChangeActiveButton extends OtpState {}

class SubmitOtpLoad extends OtpState {}

class SubmitOtpSuccess extends OtpState {}

class SubmitOtpError extends OtpState {
  final String error;
  SubmitOtpError(this.error);
}
