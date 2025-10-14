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
  HomeCubit get homeCubit => HomeCubit.get(context);
  GlobalAppCubit get globalCubit => GlobalAppCubit.get(context);

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    widget.chatsPagingController.addPageRequestListener((pageKey) {
      homeCubit.getChatsNew(pageKey, widget.chatsPagingController);
    });

    _initializeData();
  }

  Future<void> _initializeData() async {
    print("🔄 بدء تحميل البيانات...");

    // ✅ انتظر تحميل جهات الاتصال أولاً
    if (globalCubit.allContacts.isEmpty) {
      print("📞 جاري تحميل جهات الاتصال...");
      await globalCubit.requestContactsPermission();
    } else {
      print("✅ جهات الاتصال جاهزة مسبقاً");
    }

    // ✅ انتظر تحميل الـ chats الأولى
    print("💬 جاري تحميل المحادثات...");
    await homeCubit.getChatsNew(1, widget.chatsPagingController);

    // ✅ أعط وقت للـ paging controller علشان يتحمل
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLoading = false;
    });

    print("🎉 انتهى تحميل جميع البيانات");
  }

  Contact? _findContact(UserChatModel chat) {
    return PhoneUtils.findContactByPhone(
        chat.phone,
        globalCubit.allContacts
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ استخدم BlocListener بدل BlocBuilder علشان منع ال rebuilds
    return BlocListener<GlobalAppCubit, GlobalAppState>(
      listener: (context, state) {
        // استمع للتغيرات فقط بدون ما تعمل rebuild
      },
      child: _isLoading
          ? _buildLoadingWidget()
          : _buildContentWidget(),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MyProgress(),
          SizedBox(height: 16.h),
          Text(
            'Loading chats and contacts...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWidget() {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });

        await globalCubit.reloadContacts();
        widget.chatsPagingController.refresh();

        // انتظر لحد ما التحديث يخلص
        await Future.delayed(const Duration(milliseconds: 1000));

        setState(() {
          _isLoading = false;
        });
      },
      color: AppColors.lightPrimaryColor,
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) => current is DeleteChatSuccess,
        builder: (context, state) => PagedListView.separated(
          padding: EdgeInsets.only(bottom: 10.h),
          pagingController: widget.chatsPagingController,
          separatorBuilder: (_, __) => SizedBox(height: 15.h),
          builderDelegate: PagedChildBuilderDelegate<UserChatModel>(
            itemBuilder: (context, item, index) {
              final contact = _findContact(item);
              return Slidable(
                startActionPane: ActionPane(
                  motion: const BehindMotion(),
                  extentRatio: .25,
                  children: [
                    SlidableAction(
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.red,
                      icon: AppIcons.delete,
                      autoClose: true,
                      onPressed: (_) {
                        AppFunctions.showAdaptiveDialog(
                          context,
                          title: LocaleKeys.do_you_want_delete_chat.tr(),
                          actionName: LocaleKeys.delete.tr(),
                          onPress: () => homeCubit.deleteChat(item.id),
                        );
                      },
                    ),
                  ],
                ),
                child: ChatWidget(userChat: item, contact: contact),
              );
            },
            firstPageProgressIndicatorBuilder: (_) => const SizedBox.shrink(), // ❌ لا تظهر loading هنا
            firstPageErrorIndicatorBuilder: (_) =>
                TeamsErrorView(message: widget.chatsPagingController.error),
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
}