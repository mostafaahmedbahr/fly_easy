import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/features/library/models/sound_model.dart';
import 'package:new_fly_easy_new/features/library/widgets/sound_player.dart';


class SoundFullScreen extends StatelessWidget {
  const SoundFullScreen({Key? key,required this.sound}) : super(key: key);
final SoundModel sound;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      elevation: 5,
      shape: const Border.symmetric(vertical: BorderSide.none,horizontal: BorderSide.none),
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 30.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(sound.soundTitle,style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 10.h,),
            SoundPlayer(soundUrl: sound.soundUrl)
          ],
        ),
      ),
    );
  }
}
