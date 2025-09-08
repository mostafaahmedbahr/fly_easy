import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';

class ImageItem extends StatelessWidget {
  const ImageItem({
    this.path,
    this.url,
    this.remove,
    Key? key,
  }) : super(key: key);

  final String? path;
  final String? url;
  final void Function()? remove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: context.height * .9 * .18,
            width: context.height * .9 * .18,
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: path != null
                      ? Image.file(
                          File(path!),
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: url!,
                          fit: BoxFit.cover,
                        )),
            )),
        PositionedDirectional(
            end: 0,
            top: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              enableFeedback: true,
              onTap: () {
                AddChannelCubit.get(context).pickImage();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
                decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.circle,
                  color: AppColors.lightPrimaryColor,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ))
      ],
    );
  }
}
