 import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/contacts/bloc/contacts_cubit.dart';

class ContactListTile extends StatefulWidget {
  ContactListTile({
    super.key,
    required this.contact,
    required this.isSelected,
  });
  final Contact contact;
  bool isSelected;

  @override
  State<ContactListTile> createState() => _ContactListTileState();
}

class _ContactListTileState extends State<ContactListTile> {
  ContactsCubit get cubit => ContactsCubit.get(context);

  late bool isSelected;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25.w,
        backgroundColor: AppColors.lightPrimaryColor,
        child: const Icon(Icons.person),
      ),
      title: Text(
        widget.contact.displayName ?? '',
      ),
      titleTextStyle: Theme.of(context)
          .textTheme
          .labelSmall!
          .copyWith(fontWeight: FontWeight.w600),
      subtitle: Text(
          (widget.contact.phones == null || widget.contact.phones!.isEmpty)
              ? ''
              : widget.contact.phones![0].value!),
      subtitleTextStyle: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
      trailing: InkWell(
        onTap: () {
          if (isSelected) {
            cubit.unSelectContact(widget.contact.identifier!);
          } else {
            cubit.selectContact(widget.contact);
          }
          setState(() {
            isSelected = !isSelected;
          });
        },
        enableFeedback: true,
        radius: 20,
        child: Container(
          height: 25.w,
          width: 25.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Theme.of(context).indicatorColor
                  : Colors.transparent,
              border: Border.all(color: Theme.of(context).indicatorColor)),
          child: isSelected
              ? Icon(
                  Icons.check,
                  color: Theme.of(context).scaffoldBackgroundColor,
                )
              : null,
        ),
      ),
    );
  }
}
