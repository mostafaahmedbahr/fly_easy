part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class ErrorState extends SearchState {
  final String error;
  ErrorState(this.error);
}
