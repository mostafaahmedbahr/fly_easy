// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
// import 'package:new_fly_easy_new/core/download_manager/download_manager.dart';
// import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
// import 'package:new_fly_easy_new/core/injection/di_container.dart';
// import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
// import 'package:new_fly_easy_new/core/utils/colors.dart';
// import 'package:new_fly_easy_new/features/chat/bloc/chat_cubit.dart';
// import 'package:new_fly_easy_new/features/chat/models/message_model.dart';
// import 'package:new_fly_easy_new/features/chat/widgets/chat_text_field.dart';
// import 'package:new_fly_easy_new/features/chat/widgets/share_bottom_sheet.dart';
// import 'package:iconly/iconly.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
// import 'package:uuid/uuid.dart';
//
// class NewLowerSection extends StatefulWidget {
//   const NewLowerSection({Key? key}) : super(key: key);
//
//   @override
//   State<NewLowerSection> createState() => _NewLowerSectionState();
// }
//
// class _NewLowerSectionState extends State<NewLowerSection> {
//   final TextEditingController _controller = TextEditingController();
//   final StreamController<int> _streamController = StreamController<int>();
//   Timer? _timer;
//   int _seconds=0;
//   ChatCubit get cubit => ChatCubit.get(context);
//   AudioRecorder? recorder;
//   bool isRecording = false;
//   late String recordingId;
//   String? recordId;
//
//   @override
//   void initState() {
//     super.initState();
//     recorder=AudioRecorder();
//     initRecorder();
//     recordingId =  sl<Uuid>().v1();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _streamController.close();
//     _timer?.cancel();
//     _controller.dispose();
//     recorder?.dispose();
//     recorder=null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<ChatCubit, ChatState>(
//       listenWhen: (previous, current) =>
//       current is PlayMedia && current.id != recordingId,
//       listener: (context, state) => _stopRecord(false),
//       child: Container(
//         height: isRecording ? context.height * .13 : context.height * .1,
//         padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
//         decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.r),
//               topRight: Radius.circular(20.r),
//             )),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             IconButton(
//                 onPressed: _showShareContentSheet,
//                 icon:  Icon(Icons.attach_file_outlined,size: 22.sp,)),
//             Expanded(
//                 child: ChatTextField(
//                     onChange: (value) => setState(() {}),
//                     controller: _controller)),
//             _controller.text.isNullOrEmpty
//                 ? Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 StatefulBuilder(
//                     builder: (context, setState) => IconButton(
//                         onPressed: () async {
//                           if(await Permission.microphone.status==PermissionStatus.granted){
//                             if (isRecording) {
//                               _stopRecord(true);
//                             } else {
//                               _startRecord();
//                             }
//                           }
//                         },
//                         icon: !isRecording
//                             ?  Icon(
//                           IconlyLight.voice,
//                           size: 22.sp,
//                         )
//                             : Column(
//                           children: [
//                             StreamBuilder<int>(
//                                 stream: _streamController.stream,
//                                 builder: (context, snapshot) {
//                                   final duration = snapshot.hasData
//                                       ? snapshot.data!
//                                       : Duration.zero;
//                                   // final durationText =
//                                   //     '${duration.inMinutes}:${duration.inSeconds}';
//                                   return Text(
//                                     '$duration',
//                                     style: const TextStyle(
//                                         fontSize: 10),
//                                   );
//                                 }),
//                             const Icon(
//                               Icons.stop,
//                             ),
//                           ],
//                         ))),
//               ],
//             )
//                 : IconButton(
//               onPressed: () {
//                 if (cubit.teamId != null) {
//                   cubit.sendTeamTextMessage(MessageModel(
//                       senderId: HiveUtils.getUserData()!.id,
//                       senderImage: HiveUtils.getUserData()!.image,
//                       senderName: HiveUtils.getUserData()!.name,
//                       text: _controller.text,
//                       virtualId: sl<Uuid>().v1(),
//                       type: _controller.text.startsWith('https')
//                           ? MessageType.link.name
//                           : MessageType.text.name,
//                       dateTime: Timestamp.now()));
//                 } else {
//                   cubit.sendTextMessage(MessageModel(
//                       senderId: HiveUtils.getUserData()!.id,
//                       senderImage: HiveUtils.getUserData()!.image,
//                       senderName: HiveUtils.getUserData()!.name,
//                       text: _controller.text,
//                       virtualId: sl<Uuid>().v1(),
//                       type: _controller.text.startsWith('https')
//                           ? MessageType.link.name
//                           : MessageType.text.name,
//                       dateTime: Timestamp.now()
//                   ));
//                 }
//                 setState(() {
//                   _controller.clear();
//                 });
//               },
//               icon:  Icon(
//                 Icons.send,
//                 color: Colors.white,
//                 size: 22.sp,
//               ),
//               style: ButtonStyle(
//                   shape: const MaterialStatePropertyAll(CircleBorder()),
//                   backgroundColor: MaterialStatePropertyAll(
//                       CacheUtils.isDarkMode()?AppColors.lightSecondaryColor:
//                       AppColors.lightPrimaryColor
//                   ),
//                   padding: MaterialStatePropertyAll(EdgeInsets.all(5.w))),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// ///////////////////////////////////
//   /// //////////// Helper Methods ///////
//   /// ////////////////////////////////////
//   void _showShareContentSheet() {
//     showModalBottomSheet(
//       context: context,
//       isDismissible: true,
//       isScrollControlled: true,
//       backgroundColor: Theme.of(context).cardColor,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
//       builder: (context) => FractionallySizedBox(
//           heightFactor: .65,
//           child: ShareBottomSheet(
//             chatCubit: cubit,
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
//     if (!status.isDenied) {
//       // await recorder?.openRecorder();
//       // await recorder?.setSubscriptionDuration(const Duration(milliseconds: 500));
//     }
//   }
//
//   Future<void> _startRecord() async {
//     _stopAllPlayingMedia();
//     setState(() {
//       isRecording = true;
//     });
//     recordId =  sl<Uuid>().v1();
//     final path = await sl<DownloadManager>().getRecordsFilePath(recordId!);
//     await recorder?.start(const RecordConfig(),path: path,);
//     _seconds = 0;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       _seconds++;
//       _streamController.add(_seconds);
//     });
//   }
//
//   Future<void> _stopRecord(bool saveRecord) async {
//     setState(() {
//       isRecording = false;
//     },);
//     if (saveRecord) {
//       final path = await recorder?.stop();
//       _timer?.cancel();
//       cubit.saveAudioFile(path!, recordId!);
//     }
//   }
// }
