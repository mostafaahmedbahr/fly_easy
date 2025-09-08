import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/features/profile/widgets/icon_back_ground.dart';

class SettingTile extends StatelessWidget {
  const SettingTile(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTab,
      this.subTitle})
      : super(key: key);
  final String title;
  final String? subTitle;
  final IconData icon;
  final VoidCallback onTab;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      enableFeedback: true,
      child: Row(
        children: [
          IconBackGround(
            icon: Icon(
              icon,
              color: Theme.of(context).indicatorColor,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(
                  height: 5.h,
                ),
                if (subTitle != null)
                  Text(
                    subTitle!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: const Color(0xff8C8A93)),
                  )
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_sharp),
        ],
      ),
    );
  }
}
