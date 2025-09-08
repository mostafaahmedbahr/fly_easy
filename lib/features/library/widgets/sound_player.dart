import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache_manager/custom_cache_manager.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:just_audio/just_audio.dart';

class SoundPlayer extends StatefulWidget {
  const SoundPlayer({Key? key, required this.soundUrl}) : super(key: key);
  final String soundUrl;

  @override
  State<SoundPlayer> createState() => _SoundPlayerState();
}

class _SoundPlayerState extends State<SoundPlayer> {
  ThemeData get theme=>Theme.of(context);
  final player = AudioPlayer();
  Duration audioPlayerDuration = Duration.zero;
  Duration audioPlayerPosition = Duration.zero; //
  bool initialized = false;

  Future<FileInfo?> checkCachedFile(String url) async {
    var file = await sl<CustomCacheManager>().checkCachedFile(url);
    return file;
  }
  Future<void>cacheFile(String url)async{
    await sl<CustomCacheManager>().cacheFile(url);
  }

  void initPlayer() async {
    try {
      final fileInfo=await checkCachedFile(widget.soundUrl);
      if(fileInfo==null){
        audioPlayerDuration = await player.setUrl(widget.soundUrl) as Duration;
        setState(() {
          initialized = true;
        });
      } else{
        audioPlayerDuration=await player.setFilePath(fileInfo.file.path) as Duration;
        setState(() {
          initialized=true;
        });
      }
    }catch(e){
      AppFunctions.showToast(
          message: 'Invalid Sound', state: ToastStates.error);
    }
  }

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !initialized
        ? _progressBar(Duration.zero)
        : StreamBuilder<Duration>(
            stream: player.positionStream,
            builder: (context, snapshot) {
              Duration pos = snapshot.hasData ? snapshot.data! : Duration.zero;
              if (pos == audioPlayerDuration) {
                player.seek(Duration.zero);
                player.pause();
              }
              return _progressBar(pos);
            });
  }

  Widget _progressBar(Duration pos) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        initialized
            ? IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  if (player.playing) {
                    await player.stop();
                  } else {
                    await player.play();
                  }
                },
                icon: !player.playing
                    ?  Icon(
                        Icons.play_arrow,
                        color: theme.indicatorColor,
                      )
                    :  Icon(
                        Icons.stop,
                        color: theme.indicatorColor,
                      ))
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: const MyProgress()),
        SizedBox(
          width: context.width * 0.7,
          child: ProgressBar(
            thumbGlowColor: theme.indicatorColor,
            timeLabelTextStyle:  TextStyle(color: theme.indicatorColor),
            timeLabelLocation: TimeLabelLocation.sides,
            progress: pos,
            total: audioPlayerDuration,
            progressBarColor: theme.indicatorColor,
            baseBarColor: theme.indicatorColor,
            bufferedBarColor: theme.indicatorColor,
            thumbColor: theme.indicatorColor,
            barHeight: 3.0,
            thumbRadius: 5.0,
            onSeek: (duration) async {
              await player.seek(duration);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }
}
