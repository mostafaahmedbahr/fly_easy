import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/download_manager/download_manager.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_record_model.dart';
import 'package:just_audio/just_audio.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({Key? key, required this.voice}) : super(key: key);
  final ChatRecordModel voice;

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget>
    with AutomaticKeepAliveClientMixin {
  ChatCubit get cubit => ChatCubit.get(context);
  final player = AudioPlayer();
  Duration audioPlayerDuration = Duration.zero;
  Duration audioPlayerPosition = Duration.zero; //
  bool initialized = false;
  bool? isFileDownloaded;

  void initPlayer(String path) async {
    audioPlayerDuration = await player.setFilePath(path) as Duration;
    // AudioSource source = AudioSource.asset('assets/sounds/ringTone.mp3');
    // await player.setAudioSource(source);
    setState(() {
      initialized = true;
      isFileDownloaded = true;
    });

  }

  Future<String> _checkFileExist() async {
    final recordPath =
    await sl<DownloadManager>().getRecordsFilePath(widget.voice.virtualId!);
    isFileDownloaded = cubit.isRecordFileDownloaded(recordPath);
    if (isFileDownloaded!) {
      initPlayer(recordPath);
    }
    setState(() {});
    return recordPath;
  }

  @override
  void initState() {
    super.initState();
    _checkFileExist();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (previous, current) =>
      (current is PlayMedia) ||
          (current is UploadRecordSuccess &&
              current.virtualId == widget.voice.virtualId) ||
          (current is DownloadRecordSuccess &&
              current.recordId == widget.voice.virtualId),
      listener: (context, state) {
        if (state is PlayMedia && state.id != widget.voice.virtualId) {
          player.pause();
        } else if (state is UploadRecordSuccess &&
            state.virtualId == widget.voice.virtualId) {
          initPlayer(state.recordPath);
        } else if (state is DownloadRecordSuccess &&
            state.recordId == widget.voice.virtualId) {
          initPlayer(state.recordPath);
        }
      },
      child: !initialized
          ? _progressBar(Duration.zero)
          : StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, snapshot) {
            Duration pos =
            snapshot.hasData ? snapshot.data! : Duration.zero;
            if (pos == audioPlayerDuration) {
              player.seek(Duration.zero);
              player.pause();
            }
            return _progressBar(pos);
          }),
    );
  }

  Widget _progressBar(Duration pos) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        isFileDownloaded == null
            ? Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: const MyProgress(
              color: Colors.white,
            ))
            : (isFileDownloaded!)
            ? widget.voice.recordUrl != null && initialized
            ? IconButton(
            padding: EdgeInsets.zero,
            onPressed: () async {
              if (player.playing) {
                await player.stop();
              } else {
                ChatCubit.get(context)
                    .playMedia(widget.voice.virtualId!);
                await player.play();
              }
            },
            icon: !player.playing
                ? const Icon(
              Icons.play_arrow,
              color: Colors.white,
            )
                : const Icon(Icons.stop, color: Colors.white))
            : Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: const MyProgress(
              color: Colors.white,
            ))
            : BlocBuilder<ChatCubit, ChatState>(
          buildWhen: (previous, current) =>
          (current is DownloadRecordSuccess &&
              current.recordId == widget.voice.virtualId) ||
              (current is DownloadRecordLoad &&
                  current.recordId == widget.voice.virtualId),
          builder: (context, state) => state is DownloadRecordLoad
              ? Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: const MyProgress(
                color: Colors.white,
              ))
              : IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                await cubit.downloadRecordFile(
                    recordId: widget.voice.virtualId!,
                    recordUrl: widget.voice.recordUrl!);
              },
              icon: const Icon(
                Icons.download_for_offline,
                color: Colors.white,
                size: 30,
              )),
        ),
        SizedBox(
          width: context.width * 0.5,
          child: ProgressBar(
            thumbGlowColor: Colors.white,
            timeLabelTextStyle: const TextStyle(color: Colors.white),
            timeLabelLocation: TimeLabelLocation.sides,
            progress: pos,
            total: audioPlayerDuration,
            progressBarColor: Colors.white,
            baseBarColor: Colors.white,
            bufferedBarColor: Colors.white,
            thumbColor: Colors.white,
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
