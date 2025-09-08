import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_file_model.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/seen_widget.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';

class SenderFileMessage extends StatefulWidget {
  const SenderFileMessage({Key? key,
    required this.file,
    required this.dateTime,
    required this.message})
      : super(key: key);
  final ChatFileModel file;
  final MessageModel message;
  final Timestamp dateTime;

  @override
  State<SenderFileMessage> createState() => _SenderFileMessageState();
}

class _SenderFileMessageState extends State<SenderFileMessage>
    with AutomaticKeepAliveClientMixin {
  ChatCubit get cubit => ChatCubit.get(context);
  bool? isFileDownloaded;

  void _checkFileExist() async {
    isFileDownloaded = await cubit.isFileExist( widget.file.fileName!,widget.file.virtualId!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _checkFileExist();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 10.w, top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ForwardButton(message: widget.message),
              GestureDetector(
                onTap: () async {
                  if (widget.file.fileUrl != null) {
                    await cubit.openChatFile(
                        fileUrl: widget.file.fileUrl!,
                        fileName: widget.file.fileName!,
                        fileId: widget.file.virtualId!);
                    setState(() {
                      isFileDownloaded = true;
                    });
                  }
                },
                child: Container(
                  height: context.height * .105,
                  width: context.width * .7,
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsetsDirectional.all(8.h),
                  decoration: BoxDecoration(
                    color: AppColors.lightPrimaryColor.withOpacity(.9),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: isFileDownloaded != null,
                              replacement: const SizedBox.shrink(),
                              child: BlocBuilder<ChatCubit, ChatState>(
                                buildWhen: (previous, current) =>
                                (current is UploadFileSuccess &&
                                    current.virtualId ==
                                        widget.file.virtualId) ||
                                    (current is DownloadFileSuccess &&
                                        current.fileId ==
                                            widget.file.virtualId) ||
                                    (current is DownloadFileLoad &&
                                        current.fileId ==
                                            widget.file.virtualId) ||
                                    (current is DownloadFileError &&
                                        current.fileId ==
                                            widget.file.virtualId),
                                builder: (context, state) =>
                                (state
                                is DownloadFileLoad &&
                                    state.fileId ==
                                        widget.file.virtualId!) ||
                                    widget.file.fileUrl == null
                                    ? const MyProgress(
                                  color: Colors.white,
                                )
                                    : Visibility(
                                  visible: !isFileDownloaded!,
                                  replacement: cubit.getFileIcon(
                                      widget.file.fileExtension!,
                                      Colors.white),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.download_for_offline,
                                      size: 30,
                                    ),
                                    color: Colors.white,
                                    onPressed: () async {
                                      await cubit.openChatFile(
                                          fileUrl: widget.file.fileUrl!,
                                          fileName:
                                          widget.file.fileName!,
                                          fileId:
                                          widget.file.virtualId!);
                                      setState(() {
                                        isFileDownloaded = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.file.fileName!,
                                      maxLines: 2,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontFamily: AppFonts.arial),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    cubit.getFileSize(widget.file.fileSize!),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                        fontFamily: AppFonts.arial),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SeenWidget(messageId: widget.message.virtualId,
                          isSeen: widget.message.seen),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          TimeWidget(dateTime: widget.dateTime.toDate()),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
