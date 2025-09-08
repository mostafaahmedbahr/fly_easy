part of 'plans_cubit.dart';

abstract class PlansState {}

class PlansInitial extends PlansState {}

class ErrorState extends PlansState {
  final String error;
  ErrorState(this.error);
}

class GetPlansLoad extends PlansState {}

class GetPlansError extends ErrorState {
  GetPlansError(super.error);
}

class GetPlansSuccess extends PlansState {}

class ChoosePlanLoad extends PlansState {
  final int planId;
  ChoosePlanLoad(this.planId);
}

class ChoosePlanSuccess extends PlansState {}

class ChoosePlanError extends ErrorState {
  ChoosePlanError(super.error);
}
