import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/library/models/section_model.dart';

class SectionItem extends StatelessWidget {
  const SectionItem({Key? key, required this.section}) : super(key: key);
  final SectionModel section;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            context.push(Routes.librarySectionScreen, arg: section);
          },
          child: Container(
            width: 182.w,
            height: 182.w,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Theme
                  .of(context)
                  .primaryColorLight,
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
            child: Icon(
              Icons.folder_copy_rounded,
              size: 50.w,
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          section.name,
          maxLines: 1,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium!
              .copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
