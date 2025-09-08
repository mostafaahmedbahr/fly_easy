import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/features/library/bloc/section_bloc/section_cubit.dart';
import 'package:new_fly_easy_new/features/library/models/sound_model.dart';
import 'package:new_fly_easy_new/features/library/screens/sound_full_sceen.dart';


class MediaSound extends StatefulWidget {
  const MediaSound({Key? key,required this.sound}) : super(key: key);
final SoundModel sound;

  @override
  State<MediaSound> createState() => _MediaSoundState();
}

class _MediaSoundState extends State<MediaSound> {
  SectionCubit get cubit=>SectionCubit.get(context);

  Future<void>_saveFileInCache()async{
    final fileInfo=await cubit.checkCachedFile(widget.sound.soundUrl);
    if(fileInfo==null){
      cubit.cacheFile(widget.sound.soundUrl);
    }
  }
  @override
  void initState() {
    _saveFileInCache();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(context: context, builder: (context) => SoundFullScreen(sound: widget.sound),useRootNavigator: true);
          },
          child: Container(
            width: 182,
            height: 182,
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Theme.of(context).primaryColorLight,
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
              Icons.music_note_sharp,
              size: 50.w,
            ),
          ),
        ),
        SizedBox(height: 5.h,),
        Text(
          widget.sound.soundTitle,
          maxLines: 1,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

}
