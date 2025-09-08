import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_fly_easy_new/core/download_manager/download_manager.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({Key? key, required this.video}) : super(key: key);
  final VideoModel video;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> with AutomaticKeepAliveClientMixin{
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool initialized = false;
  bool isPlaying=false;

  Future<void> _initPlayer() async {
    if (widget.video.videoUrl != null) {
      // if(await sl<DownloadManager>().isVideoDownloaded(widget.video.videoVirtualId!)){
      //   String videoPath=await sl<DownloadManager>().getVideoPath(widget.video.videoVirtualId!);
      //   videoPlayerController=VideoPlayerController.file(File(videoPath));
      // }else{
      //   videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl!));
      // }
      await sl<DownloadManager>().downloadVideo(widget.video.videoUrl!, widget.video.videoVirtualId!);
      String videoPath=await sl<DownloadManager>().getVideoPath(widget.video.videoVirtualId!);
      videoPlayerController=VideoPlayerController.file(File(videoPath));
    } else {
      videoPlayerController = VideoPlayerController.file(widget.video.videoFile!);
    }
    await videoPlayerController.initialize();
    videoPlayerController.addListener(_videoPlayerListener);
    chewieController = ChewieController(
        materialProgressColors: ChewieProgressColors(
            playedColor: Colors.white, bufferedColor: Colors.black54),
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: false,
        autoInitialize: true,
        aspectRatio: 1);
    initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<ChatCubit,ChatState>(
      listenWhen: (previous, current) =>
      current is PlayMedia && current.id != widget.video.videoVirtualId,
      listener: (context, state) {
        if (state is PlayMedia && state.id != widget.video.videoVirtualId) {
          videoPlayerController.pause();
        }
      },
      child: !initialized
          ? FutureBuilder(
          future: _initPlayer(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
            // case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(
                    child: MyProgress(
                      color: Colors.white,
                    ));
              case ConnectionState.done:
                if(chewieController!=null) {
                  return Chewie(
                    controller: chewieController!,
                  );
                } else {
                  return const Center(
                      child: MyProgress(
                        color: Colors.white,
                      ));
                }
              default:
                return const Center(
                    child: MyProgress(
                      color: Colors.white,
                    ));
            }
          })
          : Chewie(
        controller: chewieController!,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController?.dispose();
  }

  void _videoPlayerListener(){
    if(videoPlayerController.value.isPlaying && !isPlaying){
      isPlaying=true;
      ChatCubit.get(context).playMedia(widget.video.videoVirtualId!);
    }else if(videoPlayerController.value.isCompleted){
      isPlaying=false;
    }else if(videoPlayerController.value.isLooping && !isPlaying){
      isPlaying=true;
      ChatCubit.get(context).playMedia(widget.video.videoVirtualId!);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
