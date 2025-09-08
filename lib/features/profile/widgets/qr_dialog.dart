import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class QrDialog extends StatefulWidget {
  const QrDialog({Key? key}) : super(key: key);

  @override
  State<QrDialog> createState() => _QrDialogState();
}

class _QrDialogState extends State<QrDialog> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog.adaptive(
          backgroundColor: Theme.of(context).cardColor,
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Screenshot(
                  controller: screenshotController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 200.h,
                        width: 200.w,
                        child: QrImageView(
                          data: HiveUtils.getUserData()!.email,
                          backgroundColor: Colors.white,
                          // eyeStyle: const QrEyeStyle(color: Colors.black),
                          version: QrVersions.auto,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                IconButton(
                  icon: const Icon(Icons.download_rounded),
                  onPressed: () {
                    screenshotController
                        .capture()
                        .then((Uint8List? image) async {
                      await ImageGallerySaverPlus.saveImage(image!);
                      AppFunctions.showToast(
                          message: 'Image Saved', state: ToastStates.error);
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
