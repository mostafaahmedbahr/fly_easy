import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../core/hive/hive_utils.dart';

ZegoUIKitPrebuiltCallController zegoUIKitPrebuiltCallController =
    ZegoUIKitPrebuiltCallController();

class CallScreen extends StatelessWidget {
  final String callId;

  const CallScreen({
    super.key,
    required this.callId,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1812799240,
      appSign:
          "f053c726dd8a0d08b2e7183517d8b26d3e7626193c0a72906f722ddd2339c82a",
      callID: callId,
      // controller: zegoUIKitPrebuiltCallController,
      plugins: [ZegoUIKitSignalingPlugin()],
      userID: HiveUtils.getUserData()!.id.toString(),
      userName: HiveUtils.getUserData()!.name,
      // controller: zegoUIKitPrebuiltCallController,
      config: ZegoUIKitPrebuiltCallConfig.groupVideoCall(),
    );
  }
}
