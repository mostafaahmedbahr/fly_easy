import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/home/bloc/home_cubit.dart';
import 'package:new_fly_easy_new/features/home/models/user_chat_model.dart';
import 'package:new_fly_easy_new/features/home/widgets/chat_widget.dart';
import 'package:new_fly_easy_new/features/teams/widgets/teams_error_view.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({Key? key, required this.chatsPagingController})
      : super(key: key);
  final PagingController<int, UserChatModel> chatsPagingController;

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  HomeCubit get cubit => HomeCubit.get(context);

  void _getInitialChats() {
    widget.chatsPagingController.addPageRequestListener((pageKey) {
      cubit.getChatsNew(pageKey, widget.chatsPagingController);
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitialChats();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async => widget.chatsPagingController.refresh(),
      color: AppColors.lightPrimaryColor,
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) => current is DeleteChatSuccess,
        builder: (context, state) => PagedListView.separated(
          padding: EdgeInsets.only(bottom: 10.h),
          pagingController: widget.chatsPagingController,
          separatorBuilder: (context, index) => SizedBox(
            height: 15.h,
          ),
          builderDelegate: PagedChildBuilderDelegate<UserChatModel>(
              itemBuilder: (context, item, index) => Slidable(
                  startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: .25,
                      children: [
                        SlidableAction(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          backgroundColor: Colors.red,
                          autoClose: true,
                          onPressed: (context) {
                            AppFunctions.showAdaptiveDialog(
                              context,
                              title: LocaleKeys.do_you_want_delete_chat.tr(),
                              actionName: LocaleKeys.delete.tr(),
                              onPress: () {
                                // cubit.deleteChannel(item.id);
                                cubit.deleteChat(item.id);
                              },
                            );
                          },
                          icon: AppIcons.delete,
                        ),
                        SizedBox(
                          width: 5.w,
                        )
                      ]),
                  child: ChatWidget(userChat: item)),
              firstPageProgressIndicatorBuilder: (_) =>
                  const Center(child: MyProgress()),
              firstPageErrorIndicatorBuilder: (context) =>
                  TeamsErrorView(message: widget.chatsPagingController.error),
              noItemsFoundIndicatorBuilder: (context) => Center(
                    child: EmptyWidget(
                      text: LocaleKeys.no_chats.tr(),
                      image: AppImages.emptyChats,
                      repeat: false,
                    ),
                  ),
              newPageProgressIndicatorBuilder: (_) =>
                  const Center(child: MyProgress())),
        ),
      ),
    );
  }
}
