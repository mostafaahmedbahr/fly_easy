import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/utils/phone_utils.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/invite_members/models/member_model.dart';
import 'package:new_fly_easy_new/features/invite_members/widgets/search_field.dart';
import 'package:new_fly_easy_new/features/search/bloc/search_cubit.dart';
import 'package:new_fly_easy_new/features/search/widgets/search_member_widget.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../app/app_bloc/app_cubit.dart';

class SearchMembersView extends StatefulWidget {
  const SearchMembersView({super.key, required this.membersPagingController});
  final PagingController<int, MemberModel> membersPagingController;

  @override
  State<SearchMembersView> createState() => _SearchMembersViewState();
}

class _SearchMembersViewState extends State<SearchMembersView>
    with AutomaticKeepAliveClientMixin<SearchMembersView> {
  late final SearchCubit _searchCubit;
  late final GlobalAppCubit _globalCubit;
  bool _isLoading = true;

  SearchCubit get cubit => SearchCubit.get(context);

  @override
  void initState() {
    super.initState();
    _searchCubit = SearchCubit.get(context);
    _globalCubit = GlobalAppCubit.get(context);

    widget.membersPagingController.addPageRequestListener((pageKey) async {
      await _loadFilteredMembers(pageKey);
    });

    _initializeData();
  }

  /// 🧠 تحميل البيانات مع فلترة المستخدمين بناءً على الكونتاكتس
  Future<void> _loadFilteredMembers(int pageKey) async {
    await cubit.getAvailableUsers(widget.membersPagingController, pageKey);

    // فلترة المستخدمين بعد ما السيرفر يرجعهم
    final originalList = widget.membersPagingController.itemList ?? [];

    final filteredList = originalList.where((member) {
      final contact = PhoneUtils.findContactByPhoneSync(
        member.phone,
        _globalCubit.allContacts,
      );
      return contact != null;
    }).toList();

    widget.membersPagingController.itemList = filteredList;
    setState(() {});
  }

  Future<void> _initializeData() async {
    if (kDebugMode) debugPrint("🔄 بدء تحميل البيانات في البحث...");

    if (_globalCubit.allContacts.isEmpty) {
      if (kDebugMode) debugPrint("📞 تحميل جهات الاتصال في البحث...");
      await _globalCubit.requestContactsPermission();
    } else {
      if (kDebugMode) debugPrint("✅ جهات الاتصال جاهزة مسبقاً في البحث");
    }

    if (kDebugMode) debugPrint("👥 تحميل الأعضاء المتاحين...");
    await _loadFilteredMembers(1);

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) setState(() => _isLoading = false);

    if (kDebugMode) debugPrint("🎉 انتهى تحميل جميع البيانات في البحث");
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await _globalCubit.reloadContacts();
    widget.membersPagingController.refresh();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isLoading = false);
  }

  Widget _buildLoadingView() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const MyProgress(),
        SizedBox(height: 16.h),
        Text(
          'Loading members and contacts...',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      ],
    ),
  );

  Widget _buildSearchContent() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.lightPrimaryColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: SearchField(
              onChange: (value) {
                if (kDebugMode) debugPrint("🔍 بحث عن: $value");
                cubit.usersSearchKey = value;
                widget.membersPagingController.refresh();
              },
              hint: LocaleKeys.search_by.tr(),
            ),
          ),
          Expanded(
            child: PagedListView.separated(
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
                bottom: 30.h,
                top: 10.h,
              ),
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              pagingController: widget.membersPagingController,
              builderDelegate: PagedChildBuilderDelegate<MemberModel>(
                itemBuilder: (context, member, index) {
                  // ✅ دلوقتى إحنا متأكدين إن الرقم ده موجود فى الكونتاكتس
                  final contact = PhoneUtils.findContactByPhoneSync(
                    member.phone,
                    _globalCubit.allContacts,
                  );

                  return SearchMemberWidget(
                    member: member,
                    index: index,
                    contact: contact,
                  );
                },
                firstPageProgressIndicatorBuilder: (_) => _isLoading
                    ? _buildLoadingView()
                    : const Center(child: MyProgress()),
                firstPageErrorIndicatorBuilder: (context) => Center(
                  child: Text('${widget.membersPagingController.error}'),
                ),
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: EmptyWidget(
                    text: "no members found",
                    image: AppImages.emptyTeams,
                  ),
                ),
                newPageProgressIndicatorBuilder: (_) =>
                    const Center(child: MyProgress()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<GlobalAppCubit, GlobalAppState>(
      listener: (_, __) {},
      child: _isLoading ? _buildLoadingView() : _buildSearchContent(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
