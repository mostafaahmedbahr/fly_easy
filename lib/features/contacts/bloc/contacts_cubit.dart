// import 'package:contacts_service/contacts_service.dart';
 import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsInitial());

  static ContactsCubit get(BuildContext context) =>
      BlocProvider.of<ContactsCubit>(context);
  List<Contact> allContacts = [];
  List<Contact> displayedContacts = [];

  Future<void> getContacts() async {
    emit(GetContactsLoad());
    try {
      allContacts = await ContactsService.getContacts();
      displayedContacts = allContacts;
      emit(GetContactsSuccess());
    } catch (error) {
      emit(GetContactsError(AppStrings.errorMessage));
    }
  }

  void searchContact(String? searchKey) {
    if (searchKey != null) {
      displayedContacts = allContacts.where((element) {
        return (element.displayName != null &&
            element.displayName!
                .toLowerCase()
                .contains(searchKey.toLowerCase()));
      }).toList();
    } else {
      displayedContacts = allContacts;
    }
    emit(SearchState());
  }

  List<Contact> selectedContacts = [];

  void selectContact(Contact contact) {
    selectedContacts.add(contact);
    emit(SelectContact());
  }

  void unSelectContact(String id) {
    selectedContacts.removeWhere((element) => element.identifier == id);
    emit(SelectContact());
  }
}
