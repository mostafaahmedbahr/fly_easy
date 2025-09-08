part of 'library_cubit.dart';

abstract class LibraryState {}

class LibraryInitial extends LibraryState {}

class GetSectionsError extends LibraryState {
  final String error;

  GetSectionsError(this.error);
}
