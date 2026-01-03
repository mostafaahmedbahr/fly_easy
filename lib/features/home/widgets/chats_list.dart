import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/utils/phone_utils.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/home/bloc/home_cubit.dart';
import 'package:new_fly_easy_new/features/home/models/user_chat_model.dart';
import 'package:new_fly_easy_new/features/home/widgets/chat_widget.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_error_view.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import '../../../app/app_bloc/app_cubit.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key, required this.chatsPagingController});
  final PagingController<int, UserChatModel> chatsPagingController;

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  late final HomeCubit _homeCubit;
  late final GlobalAppCubit _globalCubit;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit.get(context);
    _globalCubit = GlobalAppCubit.get(context);

    widget.chatsPagingController.addPageRequestListener((pageKey) {
      _homeCubit.getChatsNew(pageKey, widget.chatsPagingController);
    });

    _initializeData();
  }

  Future<void> _initializeData() async {
    debugPrint("🔄 بدء تحميل البيانات...");

    // تحميل جهات الاتصال (إن لم تكن جاهزة)
    if (_globalCubit.allContacts.isEmpty) {
      debugPrint("📞 تحميل جهات الاتصال...");
      await _globalCubit.requestContactsPermission();
    } else {
      debugPrint("✅ جهات الاتصال جاهزة مسبقاً");
    }

    // تحميل الصفحة الأولى من المحادثات
    debugPrint("💬 تحميل المحادثات...");
    await _homeCubit.getChatsNew(1, widget.chatsPagingController);

    // إعطاء وقت بسيط للـ PagingController ليُحدّث بياناته
    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() => _isLoading = false);
    }

    debugPrint("🎉 انتهى تحميل جميع البيانات");
  }

  Future<Contact?> _findContact(UserChatModel chat) async {
    return PhoneUtils.findContactByPhone(chat.phone, _globalCubit.allContacts);
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<GlobalAppCubit, GlobalAppState>(
      listener: (_, __) {},
      child: _isLoading ? _buildLoadingView() : _buildChatsList(),
    );
  }

  Widget _buildLoadingView() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const MyProgress(),
        SizedBox(height: 16.h),
        Text(
          'Loading chats and contacts...',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      ],
    ),
  );

  Widget _buildChatsList() {
    return RefreshIndicator.adaptive(
      color: AppColors.lightPrimaryColor,
      onRefresh: _onRefresh,
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (_, state) => state is DeleteChatSuccess,
        builder: (_, __) => PagedListView.separated(
          padding: EdgeInsets.only(bottom: 10.h),
          pagingController: widget.chatsPagingController,
          separatorBuilder: (_, __) => SizedBox(height: 15.h),
          builderDelegate: PagedChildBuilderDelegate<UserChatModel>(
            itemBuilder: (context, chat, index) => FutureBuilder<Contact?>(
              future: _findContact(chat),
              builder: (_, snapshot) {
                final contact = snapshot.data;

                return Slidable(
                  key: ValueKey(chat.id),
                  startActionPane: ActionPane(
                    motion: const BehindMotion(),
                    extentRatio: .25,
                    children: [
                      SlidableAction(
                        borderRadius: BorderRadius.circular(10),
                        backgroundColor: Colors.red,
                        icon: AppIcons.delete,
                        autoClose: true,
                        onPressed: (_) => AppFunctions.showAdaptiveDialog(
                          context,
                          title: LocaleKeys.do_you_want_delete_chat.tr(),
                          actionName: LocaleKeys.delete.tr(),
                          onPress: () => _homeCubit.deleteChat(chat.id),
                        ),
                      ),
                    ],
                  ),
                  child: ChatWidget(userChat: chat, contact: contact),
                );
              },
            ),
            firstPageProgressIndicatorBuilder: (_) =>
            const SizedBox.shrink(), // لا نظهر لودينغ أولي
            firstPageErrorIndicatorBuilder: (_) => TeamsErrorView(
              message: widget.chatsPagingController.error,
            ),
            noItemsFoundIndicatorBuilder: (_) => Center(
              child: EmptyWidget(
                text: LocaleKeys.no_chats.tr(),
                image: AppImages.emptyChats,
              ),
            ),
            newPageProgressIndicatorBuilder: (_) =>
            const Center(child: MyProgress()),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _globalCubit.reloadContacts(),
      Future.delayed(const Duration(milliseconds: 600)),
    ]);
    widget.chatsPagingController.refresh();
    if (mounted) setState(() => _isLoading = false);
  }
}
