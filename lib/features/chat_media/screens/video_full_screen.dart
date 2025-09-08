import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFullScreen extends StatefulWidget {
  const VideoFullScreen({Key? key, required this.videoController})
      : super(key: key);
  final VideoPlayerController videoController;

  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
  late ChewieController chewieController;

  void _initController() {
    chewieController = ChewieController(
        materialProgressColors: ChewieProgressColors(
            playedColor: Colors.white, bufferedColor: Colors.black54),
        videoPlayerController: widget.videoController,
        autoPlay: false,
        looping: false,
        autoInitialize: true,
        aspectRatio: 1);
  }

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(controller: chewieController),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    closeControllers();
  }

  void closeControllers() async {
    widget.videoController.pause();
    chewieController.dispose();
  }
}
