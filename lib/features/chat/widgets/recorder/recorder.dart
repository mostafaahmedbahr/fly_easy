import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_fly_easy_new/features/chat/widgets/recorder/android_recorder.dart';
import 'package:new_fly_easy_new/features/chat/widgets/recorder/ios_recorder.dart';

class Recorder extends StatefulWidget {
  const Recorder({super.key});

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid){
      return const AndroidRecorder();
    }else{
     // return const IosRecorder();
    return const SizedBox();
    }
  }
}
