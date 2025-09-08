// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:new_fly_easy_new/core/download_manager/download_manager.dart';
// import 'package:new_fly_easy_new/core/injection/di_container.dart';
// import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
// import 'package:iconly/iconly.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
// import 'package:uuid/uuid.dart';
//
// class IosRecorder extends StatefulWidget {
//   const IosRecorder({super.key});
//
//   @override
//   State<IosRecorder> createState() => _IosRecorderState();
// }
//
// class _IosRecorderState extends State<IosRecorder> {
//   final StreamController<Duration> _streamController = StreamController<Duration>.broadcast();
//   Timer? _timer;
//
//   ChatCubit get cubit => ChatCubit.get(context);
//   late AudioRecorder recorder;
//   bool isRecording = false;
//   late String recordingId;
//   String? recordId;
//
//   @override
//   void initState() {
//     super.initState();
//     recorder = AudioRecorder();
//     initRecorder();
//     recordingId = sl<Uuid>().v1();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _streamController.close();
//     _timer?.cancel();
//     recorder.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<ChatCubit, ChatState>(
//       listenWhen: (previous, current) =>
//       current is PlayMedia && current.id != recordingId,
//       listener: (context, state) => _stopRecord(false),
//       child: IconButton(
//           onPressed: () async {
//             if (await Permission.microphone.status ==
//                 PermissionStatus.granted) {
//               if (isRecording) {
//                 _stopRecord(true);
//               } else {
//                 _startRecord();
//               }
//             }else{
//               initRecorder();
//             }
//           },
//           icon: !isRecording
//               ? Icon(
//             IconlyLight.voice,
//             size: 22.sp,
//           )
//               : Column(
//             children: [
//               StreamBuilder<Duration>(
//                   stream: _streamController.stream,
//                   builder: (context, snapshot) {
//                     final duration = snapshot.hasData
//                         ? snapshot.data!
//                         : Duration.zero;
//                     final durationText =
//                         '${duration.inMinutes}:${duration.inSeconds}';
//                     return Text(
//                       durationText,
//                       style: const TextStyle(
//                           fontSize: 10),
//                     );
//                   }),
//               const Icon(
//                 Icons.stop,
//               ),
//             ],
//           )),
//     );
//   }
//
//   void _stopAllPlayingMedia() {
//     cubit.playMedia(recordingId);
//   }
//
//   Future<void> initRecorder() async {
//     final status = await Permission.microphone.request();
//   }
//
//   Future<void> _startRecord() async {
//     _stopAllPlayingMedia();
//     setState(() {
//       isRecording = true;
//     });
//     recordId = sl<Uuid>().v1();
//     final path = await sl<DownloadManager>().getRecordsFilePath(recordId!);
//     await recorder.start(const RecordConfig(), path: path,);
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       _streamController.add(Duration(seconds: timer.tick,minutes: (timer.tick/60).floor()));
//     });
//   }
//
//   Future<void> _stopRecord(bool saveRecord) async {
//     setState(() {
//       isRecording = false;
//     },);
//     if (saveRecord) {
//       final path = await recorder.stop();
//       _timer?.cancel();
//       cubit.saveAudioFile(path!, recordId!);
//     }
//   }
// }
