import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/contacts/bloc/contacts_cubit.dart';
import 'package:new_fly_easy_new/features/contacts/widgets/contact_tile.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/search_field.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key, required this.chatCubit}) : super(key: key);
  final ChatCubit chatCubit;

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  ContactsCubit get cubit => ContactsCubit.get(context);

  @override
  void initState() {
    super.initState();
    // Future.microtask(() => cubit.getContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.select_contacts.tr()),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back,
              size: 30.w,
            )),
      ),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        buildWhen: (previous, current) =>
            current is GetContactsError ||
            current is GetContactsSuccess ||
            current is GetContactsLoad ,
        builder: (context, state) => (state is GetContactsSuccess)
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: SearchField(
                      hint: LocaleKeys.search.tr(),
                      onChange: (value) {
                        // cubit.searchContact(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  // Expanded(
                  //   child: BlocBuilder<ContactsCubit,ContactsState>(
                  //     buildWhen: (previous, current) => current is SearchState,
                  //     builder: (context, state) =>  ListView.separated(
                  //       addAutomaticKeepAlives: false,
                  //       itemBuilder: (context, index) => ContactListTile(
                  //         contact: cubit.displayedContacts[index],
                  //         isSelected: cubit.selectedContacts.contains(cubit.displayedContacts[index]),
                  //       ),
                  //       separatorBuilder: (context, index) => const Divider(
                  //         color: Colors.grey,
                  //         endIndent: 10,
                  //         indent: 10,
                  //       ),
                  //       itemCount: cubit.displayedContacts.length,
                  //     ),
                  //   ),
                  // ),
                ],
              )
            : const MyProgress(),
      ),
      // floatingActionButton: BlocBuilder<ContactsCubit, ContactsState>(
      //   buildWhen: (previous, current) => current is SelectContact,
      //   builder: (context, state) => cubit.selectedContacts.isNotEmpty
      //       ? FloatingActionButton(
      //           backgroundColor: AppColors.lightPrimaryColor,
      //           onPressed: () {
      //             widget.chatCubit.getSelectedContacts(cubit.selectedContacts);
      //             context.pop();
      //           },
      //           child: const Icon(
      //             Icons.send,
      //             color: Colors.white,
      //           ),
      //         )
      //       : const SizedBox.shrink(),
      // ),
    );
  }
}
