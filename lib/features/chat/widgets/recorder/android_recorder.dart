import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:new_fly_easy_new/core/download_manager/download_manager.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
import 'package:iconly/iconly.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class AndroidRecorder extends StatefulWidget {
  const AndroidRecorder({super.key,});
  @override
  State<AndroidRecorder> createState() => _AndroidRecorderState();
}

class _AndroidRecorderState extends State<AndroidRecorder> {

  ChatCubit get cubit => ChatCubit.get(context);
  late FlutterSoundRecorder recorder;
  bool isRecording = false;
  late String recordingId;
  String? recordId;

  @override
  void initState() {
    super.initState();
    recorder=FlutterSoundRecorder();
    initRecorder();
    recordingId = sl<Uuid>().v1();
  }

  @override
  void dispose() {
    super.dispose();
    recorder.closeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (previous, current) =>
      current is PlayMedia && current.id != recordingId,
      listener: (context, state) => _stopRecord(false),
      child: IconButton(
          onPressed: () async {
            if (await Permission.microphone.status ==
                PermissionStatus.granted) {
              if (isRecording) {
                _stopRecord(true);
              } else {
                _startRecord();
              }
            }else{
              Permission.microphone.request();
            }
          },
          icon: !isRecording
              ? Icon(
            IconlyLight.voice,
            size: 22.sp,
          )
              : Column(
            children: [
              StreamBuilder<RecordingDisposition>(
                  stream: recorder.onProgress,
                  builder: (context, snapshot) {
                    final duration = snapshot.hasData
                        ? snapshot.data!.duration
                        : Duration.zero;
                    final durationText =
                        '${duration.inMinutes}:${duration.inSeconds}';
                    return Text(
                      durationText,
                      style: const TextStyle(
                          fontSize: 10),
                    );
                  }),
              const Icon(
                Icons.stop,
              ),
            ],
          )),
    );
  }

  void _stopAllPlayingMedia() {
    cubit.playMedia(recordingId);
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (!status.isDenied) {
      await recorder.openRecorder();
      await recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    }
  }

  Future<void> _startRecord() async {
    _stopAllPlayingMedia();
    setState(() {
      isRecording = true;
    });
    recordId = sl<Uuid>().v1();
    final path = await sl<DownloadManager>().getRecordsFilePath(recordId!);
    await recorder.startRecorder(toFile: path,codec: Codec.aacMP4);
  }

  Future<void> _stopRecord(bool saveRecord) async {
    setState((){
        isRecording = false;
      },);
    isRecording = false;
    if (saveRecord) {
      final path = await recorder.stopRecorder();
      cubit.saveAudioFile(path!, recordId!);
    }
  }
}
