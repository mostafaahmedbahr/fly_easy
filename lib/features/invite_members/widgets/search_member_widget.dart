import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';

import 'package:new_fly_easy_new/features/invite_members/widgets/search_field.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class SearchMemberWidget extends StatefulWidget {
  const SearchMemberWidget({Key? key, required this.onSearch})
      : super(key: key);
  // final PagingController<int, MemberModel> pagingController;
  final Function(String? value) onSearch;
  @override
  State<SearchMemberWidget> createState() => _SearchMemberWidgetState();
}

class _SearchMemberWidgetState extends State<SearchMemberWidget> {
  // InviteMembersCubit get cubit => InviteMembersCubit.get(context);
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: SearchField(
                hint: LocaleKeys.search_by.tr(),
                controller: _searchController,
                onChange: widget.onSearch,
              ),
            ),
            IconButton(
                onPressed: () async {
                  Object? qrValue = await Navigator.pushNamed(context, Routes.scanQr);
                  if (qrValue != null) {
                    setState(() {
                      _searchController.text = qrValue.toString();
                    });
                    widget.onSearch(qrValue.toString());
                    // cubit.searchKey = qrValue.toString();
                    // widget.pagingController.refresh();
                  }
                },
                icon: const Icon(Icons.qr_code_scanner))
          ],
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
