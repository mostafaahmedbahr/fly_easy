import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:easy_localization/easy_localization.dart';
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

    widget.membersPagingController.addPageRequestListener((pageKey) {
      cubit.getAvailableUsers(widget.membersPagingController, pageKey);
    });

    _initializeData();
  }

  Future<void> _initializeData() async {
    debugPrint("🔄 بدء تحميل البيانات في البحث...");

    // تحميل جهات الاتصال (إن لم تكن جاهزة)
    if (_globalCubit.allContacts.isEmpty) {
      debugPrint("📞 تحميل جهات الاتصال في البحث...");
      await _globalCubit.requestContactsPermission();
    } else {
      debugPrint("✅ جهات الاتصال جاهزة مسبقاً في البحث");
    }

    // تحميل الصفحة الأولى من الأعضاء
    debugPrint("👥 تحميل الأعضاء المتاحين...");
    await cubit.getAvailableUsers(widget.membersPagingController, 1);

    // إعطاء وقت بسيط للـ PagingController ليُحدّث بياناته
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() => _isLoading = false);
    }

    debugPrint("🎉 انتهى تحميل جميع البيانات في البحث");
  }

  Future<Contact?> _findContact(MemberModel member) async {
    return PhoneUtils.findContactByPhone(member.phone, _globalCubit.allContacts);
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _globalCubit.reloadContacts(),
      Future.delayed(const Duration(milliseconds: 600)),
    ]);
    widget.membersPagingController.refresh();
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
                debugPrint("بحث عن: $value");
                cubit.usersSearchKey = value;
                widget.membersPagingController.refresh();
              },
              hint: LocaleKeys.search_by.tr(),
            ),
          ),
          Expanded(
            child: PagedListView.separated(
              padding: EdgeInsets.only(
                  left: 15.w, right: 15.w, bottom: 30.h, top: 10.h),
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              pagingController: widget.membersPagingController,
              builderDelegate: PagedChildBuilderDelegate<MemberModel>(
                itemBuilder: (context, member, index) => FutureBuilder<Contact?>(
                  future: _findContact(member),
                  builder: (_, snapshot) {
                    final contact = snapshot.data;
                    return SearchMemberWidget(
                      member: member,
                      index: index,
                      contact: contact, // تمرير جهة الاتصال للويدجت
                    );
                  },
                ),
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
                newPageProgressIndicatorBuilder: (_) => const Center(child: MyProgress()),
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