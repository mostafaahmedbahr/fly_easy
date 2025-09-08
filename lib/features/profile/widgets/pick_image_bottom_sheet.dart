import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/features/profile/bloc/profile_cubit.dart';
import 'package:new_fly_easy_new/features/profile/widgets/icon_back_ground.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  const ImageSourceBottomSheet({Key? key, required this.cubit})
      : super(key: key);
  final ProfileCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.r), topLeft: Radius.circular(20.r))),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // InkWell(
                //   onTap: () => context.pop(),
                //   child: Icon(
                //     Icons.close,
                //     color: Theme.of(context).textTheme.labelSmall!.color,
                //   ),
                // ),
                Text(
                  'Personal Photo',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ImageSourceItem(
                title: 'Camera',
                icon: AppIcons.camera,
                onTab: () {
                  cubit.pickImage(source: ImageSource.camera);
                },
              ),
              ImageSourceItem(
                title: 'Gallery',
                icon: AppIcons.picture,
                onTab: () {
                  cubit.pickImage(source: ImageSource.gallery);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class ImageSourceItem extends StatelessWidget {
  const ImageSourceItem(
      {Key? key, required this.title, required this.icon, required this.onTab})
      : super(key: key);
  final IconData icon;
  final String title;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Row(
        children: [
          IconBackGround(icon: Icon(icon)),
          SizedBox(
            width: 5.w,
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
          )
        ],
      ),
    );
  }
}
