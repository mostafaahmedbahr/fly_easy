import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/team_chat_media_bloc/chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/widgets/chat_media_link.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ChatLinksView extends StatefulWidget {
  const ChatLinksView({Key? key}) : super(key: key);

  @override
  State<ChatLinksView> createState() => _ChatLinksViewState();
}

class _ChatLinksViewState extends State<ChatLinksView>
    with AutomaticKeepAliveClientMixin {
  ChatMediaCubit get cubit => ChatMediaCubit.get(context);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => cubit.getLinks());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ChatMediaCubit, ChatMediaState>(
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
