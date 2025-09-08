import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:new_fly_easy_new/core/cache_manager/custom_cache_manager.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_video_model.dart';
import 'package:video_player/video_player.dart';

class ChatMediaVideo extends StatefulWidget {
  const ChatMediaVideo({Key? key, required this.video}) : super(key: key);
  final VideoModel video;

  @override
  State<ChatMediaVideo> createState() => _ChatMediaVideoState();
}

class _ChatMediaVideoState extends State<ChatMediaVideo>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController videoPlayerController;
  bool initialized = false;

  Future<void> _initPlayer() async {
    final fileInfo = await checkCachedFile(widget.video.videoUrl!);
    if(fileInfo==null) {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl!));
      await videoPlayerController.initialize();
      cacheFile(widget.video.videoUrl!);
      videoPlayerController.play();
      initialized = true;
    }else{
      final file=fileInfo.file;
      videoPlayerController=VideoPlayerController.file(file);
      await videoPlayerController.initialize();
      videoPlayerController.play();
      initialized = true;
    }
  }

  Future<FileInfo?> checkCachedFile(String url) async {
    var file = await sl<CustomCacheManager>().checkCachedFile(url);
    return file;
  }
  Future<void>cacheFile(String url)async{
    await sl<CustomCacheManager>().cacheFile(url);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[300],
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 35,
              offset: Offset(0, 20),
              spreadRadius: 0,
            )
          ]),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: !initialized
          ? FutureBuilder(
          future: _initPlayer(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.done:
                videoPlayerController.pause();
                return GestureDetector(
                  onTap: () =>
                      sl<AppRouter>()
                          .navigatorKey
                          .currentState!
                          .pushNamed(Routes.videoFullScreen,
                          arguments: videoPlayerController),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(videoPlayerController),
                      const Icon(Icons.play_arrow,
                          color: Colors.white, size: 30),
                    ],
                  ),
                );
              default:
                return const Center(
                    child: MyProgress(
                      color: AppColors.lightPrimaryColor,
                    ));
            }
          })
          : Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(videoPlayerController),
          const Icon(Icons.play_arrow, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
