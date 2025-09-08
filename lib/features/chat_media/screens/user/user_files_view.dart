import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/user_chat_media_bloc/user_chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/chat_media/widgets/chat_media_file.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class UserChatFilesView extends StatefulWidget {
  const UserChatFilesView({Key? key}) : super(key: key);

  @override
  State<UserChatFilesView> createState() => _UserChatFilesViewState();
}

class _UserChatFilesViewState extends State<UserChatFilesView>
    with AutomaticKeepAliveClientMixin {
  UserChatMediaCubit get cubit => UserChatMediaCubit.get(context);

  @override
  void initState() {
    Future.microtask(() => cubit.getFiles());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<UserChatMediaCubit, UserChatMediaState>(
      buildWhen: (previous, current) =>
          current is GetFilesError ||
          current is GetFilesSuccess ||
          current is GetFilesLoad,
      builder: (context, state) => state is GetFilesSuccess
          ? cubit.files.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) => ChatMediaFile(
                        file: cubit.files[index],
                        fileIcon: cubit.getFileIcon(index),
                        fileSize:
                            cubit.getFileSize(cubit.files[index].fileSize!),
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
