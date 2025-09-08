import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/widgets/dialog_progress_indicator.dart';
import 'package:new_fly_easy_new/features/library/bloc/section_bloc/section_cubit.dart';
import 'package:new_fly_easy_new/features/library/models/file_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class MediaFile extends StatefulWidget {
  const MediaFile({Key? key, required this.file}) : super(key: key);
  final FileModel file;

  @override
  State<MediaFile> createState() => _MediaFileState();
}

class _MediaFileState extends State<MediaFile> {
  SectionCubit get cubit => SectionCubit.get(context);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _onFilePressed,
          child: Container(
            width: 182,
            height: 182,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Theme.of(context).primaryColorLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.31.r),
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
            child: Icon(
              Icons.file_copy_outlined,
              size: 50.w,
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          widget.file.name,
          maxLines: 1,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Future<File> fetchFileFromUrl(String url) async {
    Dio dio = Dio();

    // Specify the file save path and name
    Directory tempDir = await getTemporaryDirectory();
    String savePath = '${tempDir.path}/tempfile.pdf';

    // Download the file and save it to the path
    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {},
    );
    return File(savePath);
  }

  void _onFilePressed() async {
    final fileInfo =
        await SectionCubit.get(context).checkCachedFile(widget.file.fileUrl);
    if (fileInfo == null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => const DialogIndicator(),
        );
        final cachedFile =
            await SectionCubit.get(context).cacheFile(widget.file.fileUrl);
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
          // sl<AppRouter>().navigatorKey.currentState!.push(MaterialPageRoute(
          //       builder: (context) => FileScreen(
          //           filePath: cachedFile.path, fileName: widget.file.name),
          //     ));

        OpenFile.open(cachedFile.path);
      }
    } else {
      OpenFile.open(fileInfo.file.path);
      // if (context.mounted) {
      //   sl<AppRouter>().navigatorKey.currentState!.push(MaterialPageRoute(
      //     builder: (context) => FileScreen(
      //         filePath: fileInfo.file.path, fileName: widget.file.name),
      //   ));
      // }
    }
    // final downloadedFile = await fetchFileFromUrl(file.fileUrl);
    // OpenFile.open(downloadedFile.path);
  }
}
