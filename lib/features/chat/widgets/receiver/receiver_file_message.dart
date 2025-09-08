import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
import 'package:new_fly_easy_new/features/chat/widgets/forward_button.dart';
import 'package:new_fly_easy_new/features/chat/widgets/time_widget.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';

class ReceiverFileMessage extends StatefulWidget {
  const ReceiverFileMessage({
    Key? key,
    required this.message,
    required this.isSameSender,
    required this.isGroup,
  }) : super(key: key);
  final MessageModel message;
  final bool isSameSender;
  final bool isGroup;

  @override
  State<ReceiverFileMessage> createState() => _ReceiverFileMessageState();
}

class _ReceiverFileMessageState extends State<ReceiverFileMessage> {
  ChatCubit get cubit => ChatCubit.get(context);
  bool? isFileDownloaded;

  void _checkFileExist() async {
    isFileDownloaded = await cubit.isFileExist(widget.message.files![0].fileName!,widget.message.files![0].virtualId!);
    setState(() {});
  }

  @override
  void initState() {
    _checkFileExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isGroup) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
          start: widget.isSameSender ? 45.w : 5.w,
          top: widget.isSameSender ? 0 : 10.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: !widget.isSameSender,
                    replacement: const SizedBox.shrink(),
                    child: CircleNetworkImage(
                        width: 40.w, imageUrl: widget.message.senderImage!)),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !widget.isSameSender,
                      replacement: const SizedBox.shrink(),
                      child: Text(
                        textAlign: TextAlign.start,
                        widget.message.senderName!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontFamily: AppFonts.arial,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (widget.message.files![0].fileUrl != null) {
                              await cubit.openChatFile(
                                  fileUrl: widget.message.files![0].fileUrl!,
                                  fileName: widget.message.files![0].fileName!,
                                  fileId: widget.message.files![0].virtualId!);
                              setState(() {
                                isFileDownloaded = true;
                              });
                            }
                          },
                          child: Container(
                            height: context.height * .09,
                            width: context.width * .7,
                            alignment: AlignmentDirectional.center,
                            padding: EdgeInsetsDirectional.all(3.h),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.lightSecondaryColor.withOpacity(.9),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: isFileDownloaded != null,
                                  replacement: const SizedBox.shrink(),
                                  child: BlocBuilder<ChatCubit, ChatState>(
                                    buildWhen: (previous, current) =>
                                        (current is DownloadFileSuccess &&
                                            current.fileId ==
                                                widget.message.files![0]
                                                    .virtualId) ||
                                        (current is DownloadFileLoad &&
                                            current.fileId ==
                                                widget.message.files![0]
                                                    .virtualId) ||
                                        (current is DownloadFileError &&
                                            current.fileId ==
                                                widget.message.files![0]
                                                    .virtualId),
                                    builder: (context, state) => (state
                                                    is DownloadFileLoad &&
                                                state.fileId ==
                                                    widget.message.files![0]
                                                        .virtualId!) ||
                                            widget.message.files![0].fileUrl ==
                                                null
                                        ? const MyProgress(
                                      color: Colors.white,
                                    )
                                        : Visibility(
                                            visible: !isFileDownloaded!,
                                            replacement: cubit.getFileIcon(
                                                widget.message.files![0]
                                                    .fileExtension!,
                                                Colors.white),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.download_for_offline,
                                                size: 30,
                                              ),
                                              color: Colors.white,
                                              onPressed: () async {
                                                await cubit.openChatFile(
                                                    fileUrl: widget.message
                                                        .files![0].fileUrl!,
                                                    fileName: widget.message
                                                        .files![0].fileName!,
                                                    fileId: widget.message
                                                        .files![0].virtualId!);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.message.files![0].fileName!,
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
                                        cubit.getFileSize(
                                            widget.message.files![0].fileSize!),
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
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        TimeWidget(dateTime: widget.message.dateTime.toDate()),
                      ],
                    )
                  ],
                ),
              ],
            ),
            ForwardButton(message: widget.message),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsetsDirectional.only(
            start: 7.w, top: widget.isSameSender ? 5 : 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (widget.message.files![0].fileUrl != null) {
                      await cubit.openChatFile(
                          fileUrl: widget.message.files![0].fileUrl!,
                          fileName: widget.message.files![0].fileName!,
                          fileId: widget.message.files![0].virtualId!);
                      setState(() {
                        isFileDownloaded = true;
                      });
                    }
                  },
                  child: Container(
                    height: context.height * .09,
                    width: context.width * .7,
                    alignment: AlignmentDirectional.center,
                    padding: EdgeInsetsDirectional.all(3.h),
                    decoration: BoxDecoration(
                      color: AppColors.lightSecondaryColor.withOpacity(.9),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: isFileDownloaded != null,
                          replacement: const SizedBox.shrink(),
                          child: BlocBuilder<ChatCubit, ChatState>(
                            buildWhen: (previous, current) =>
                                (current is DownloadFileSuccess &&
                                    current.fileId ==
                                        widget.message.files![0].virtualId) ||
                                (current is DownloadFileLoad &&
                                    current.fileId ==
                                        widget.message.files![0].virtualId) ||
                                (current is DownloadFileError &&
                                    current.fileId ==
                                        widget.message.files![0].virtualId),
                            builder: (context, state) => (state
                                            is DownloadFileLoad &&
                                        state.fileId ==
                                            widget.message.files![0]
                                                .virtualId!) ||
                                    widget.message.files![0].fileUrl == null
                                ? const MyProgress(
                              color: Colors.white,
                            )
                                : Visibility(
                                    visible: !isFileDownloaded!,
                                    replacement: cubit.getFileIcon(
                                        widget.message.files![0].fileExtension!,
                                        Colors.white),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.download_for_offline,
                                        size: 30,
                                      ),
                                      color: Colors.white,
                                      onPressed: () async {
                                        await cubit.openChatFile(
                                            fileUrl: widget
                                                .message.files![0].fileUrl!,
                                            fileName: widget
                                                .message.files![0].fileName!,
                                            fileId: widget
                                                .message.files![0].virtualId!);
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
                                  widget.message.files![0].fileName!,
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
                                cubit.getFileSize(
                                    widget.message.files![0].fileSize!),
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
                ),
                SizedBox(
                  height: 3.h,
                ),
                TimeWidget(dateTime: widget.message.dateTime.toDate()),
              ],
            ),
            ForwardButton(message: widget.message)
          ],
        ),
      );
    }
  }
}
