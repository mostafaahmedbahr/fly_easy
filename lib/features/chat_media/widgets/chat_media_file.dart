import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_file_model.dart';

class ChatMediaFile extends StatefulWidget {
  const ChatMediaFile(
      {Key? key,
      required this.file,
      required this.fileSize,
      required this.fileIcon,
      required this.onPress})
      : super(key: key);
  final ChatFileModel file;
  final Widget fileIcon;
  final String fileSize;
  final void Function()? onPress;

  @override
  State<ChatMediaFile> createState() => _ChatMediaFileState();
}

class _ChatMediaFileState extends State<ChatMediaFile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0x2607A6B9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.31),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 35,
            offset: Offset(0, 20),
            spreadRadius: 0,
          )
        ],
      ),
      child: ListTile(
        enableFeedback: true,
        onTap: widget.onPress,
        leading: widget.fileIcon,
        title: Text(widget.file.fileName!),
        titleTextStyle: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.w600, fontSize: 16.sp),
        subtitle: Text(widget.fileSize),
        subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  void _show() {
    showAdaptiveDialog(
      useRootNavigator: true,
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          content: MyProgress(
            color: AppColors.lightPrimaryColor,
          )),
    );
  }
}
