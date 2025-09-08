import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/team_chat_media_bloc/chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/widgets/chat_media_file.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ChatFilesView extends StatefulWidget {
  const ChatFilesView({Key? key}) : super(key: key);

  @override
  State<ChatFilesView> createState() => _ChatFilesViewState();
}

class _ChatFilesViewState extends State<ChatFilesView>
    with AutomaticKeepAliveClientMixin {
  ChatMediaCubit get cubit => ChatMediaCubit.get(context);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => cubit.getFiles());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ChatMediaCubit, ChatMediaState>(
      buildWhen: (previous, current) =>
          current is GetFilesError ||
          current is GetFilesSuccess ||
          current is GetFilesLoad,
      builder: (context, state) => state is GetFilesSuccess
          ? cubit.files.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) => ChatMediaFile(
                        file: cubit.files[index],
                        fileSize:
                            cubit.getFileSize(cubit.files[index].fileSize!),
                        fileIcon: cubit.getFileIcon(index),
                        onPress: () {
                          cubit.openFile(index: index);
                        },
                      ),
                  separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Divider(
                          color: Colors.grey[300],
                          indent: 10.w,
                          endIndent: 10.w,
                        ),
                      ),
                  itemCount: cubit.files.length)
              : EmptyWidget(
                  text: LocaleKeys.no_files_in_chat.tr(),
                  image: AppImages.emptyMedia)
          : const MyProgress(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
