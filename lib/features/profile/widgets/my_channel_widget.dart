import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/features/teams/models/team_model.dart';
import 'package:new_fly_easy_new/features/widgets/circle_network_image.dart';

class MyChannelWidget extends StatelessWidget {
  const MyChannelWidget({Key? key,required this.channel}) : super(key: key);
final TeamModel channel;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding:  EdgeInsets.symmetric(horizontal: 20..w, vertical: 15.h),
        decoration: ShapeDecoration(
          color: Theme.of(context).primaryColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
    child:  InkWell(
      onTap: () {},
      enableFeedback: true,
      child: Row(
        children: [
          CircleNetworkImage(width: 40.w, imageUrl: channel.image),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  channel.name,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(
                  height: 5.h,
                ),
                  Text(
                    'channels:${channel.communities}',
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
    ),
    );
  }
}
