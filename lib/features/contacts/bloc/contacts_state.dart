part of 'contacts_cubit.dart';

@immutable
abstract class ContactsState {}

class ContactsInitial extends ContactsState {}

class GetContactsLoad extends ContactsState {}

class GetContactsSuccess extends ContactsState {}

class GetContactsError extends ContactsState {
  final String error;
  GetContactsError(this.error);
}

class SearchState extends ContactsState {}

class SelectContact extends ContactsState {}
