import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/user_chat_media_bloc/user_chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/widgets/chat_media_link.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class UserChatLinksView extends StatefulWidget {
  const UserChatLinksView({Key? key}) : super(key: key);

  @override
  State<UserChatLinksView> createState() => _UserChatLinksViewState();
}

class _UserChatLinksViewState extends State<UserChatLinksView>
    with AutomaticKeepAliveClientMixin {
  UserChatMediaCubit get cubit => UserChatMediaCubit.get(context);

  @override
  void initState() {
    Future.microtask(() => cubit.getLinks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<UserChatMediaCubit, UserChatMediaState>(
      listenWhen: (previous, current) =>
          current is GetLinksError ||
          current is GetLinksSuccess ||
          current is GetMediaLoad,
      listener: (context, state) {
        if (state is GetLinksError) {
          AppFunctions.showToast(
              message: state.error, state: ToastStates.error);
        }
      },
      buildWhen: (previous, current) =>
          current is GetLinksSuccess ||
          current is GetLinksError ||
          current is GetLinksLoad,
      builder: (context, state) => state is GetLinksSuccess
          ? cubit.links.isNotEmpty
              ? ListView.separated(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                  itemBuilder: (context, index) =>
                      ChatMedialLink(link: cubit.links[index]),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 15.h,
                      ),
                  itemCount: cubit.links.length)
              : EmptyWidget(
                  text: LocaleKeys.no_links_in_chat.tr(),
                  image: AppImages.emptyMedia)
          : const MyProgress(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
