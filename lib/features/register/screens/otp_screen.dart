import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/forget_password/widgets/upper_widget.dart';
import 'package:new_fly_easy_new/features/register/bloc/otp_cubit/otp_cubit.dart';
import 'package:new_fly_easy_new/features/register/widgets/pin_fields.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/features/widgets/inactive_button.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import "package:zego_uikit/src/components/audio_video_container/layout.dart";

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpCubit get cubit => OtpCubit.get(context);
  final TextEditingController _controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String otp;

  // Timer variables
  late int _countdown;
  late Timer _timer;
  bool _showResendButton = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 30;
      _showResendButton = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _showResendButton = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(
      listener: _blocListener,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back)),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UpperWidget(
                      title: LocaleKeys.enter_otp.tr(),
                      imagePath: AppImages.email,
                      subTitle: LocaleKeys.enter_otp_sent.tr()),
                  PinCodeFields(
                    context: context,
                    onSave: (value) {
                      otp = value!;
                    },
                    controller: _controller,
                    onChange: (value) {
                      _checkActiveButton();
                    },
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(height: 100.h),
                  BlocBuilder<OtpCubit, OtpState>(
                    builder: (context, state) => cubit.isActiveButton
                        ? CustomButton(
                        width: double.infinity,
                        onPress: () async {
                          formKey.currentState!.save();
                          await cubit.submitOtp(otp);
                        },
                        buttonType: 1,
                        child: state is SubmitOtpLoad
                            ? const MyProgress(
                          color: Colors.white,
                        )
                            : ButtonText(title: LocaleKeys.verify.tr()))
                        : InactiveButton(
                        width: double.infinity,
                        title: ButtonText(
                          title: LocaleKeys.verify.tr(),
                        )),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.did_not_get_otp.tr(),
                        style: const TextStyle(
                          color: Color(0xFF3A4053),
                          fontSize: 15.32,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w400,
                          height: 0.10,
                        ),
                      ),
                      _showResendButton
                          ? TextButton(
                          onPressed: () {
                            cubit.resendOtp(widget.email);
                            _startCountdown(); // Restart the timer after resend
                          },
                          child: Text(
                            LocaleKeys.resend_otp.tr(),
                            style: const TextStyle(
                              color: Color(0xFF3461FD),
                              fontSize: 15.32,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w400,
                              height: 0.10,
                            ),
                          ))
                          : Text(
                        ' (${_countdown}s)',
                        style: const TextStyle(
                          color: Color(0xFF3A4053),
                          fontSize: 15.32,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w400,
                          height: 0.10,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ////////////////////////////////////////////
  /// /////////////// Helper Methods //////////////
  /// ////////////////////////////////////////////

  void _blocListener(BuildContext context, OtpState state) {
    if (state is SubmitOtpSuccess) {
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID:  1812799240/*input your AppID*/,
        appSign: 'f053c726dd8a0d08b2e7183517d8b26d3e7626193c0a72906f722ddd2339c82a' /*input your AppSign*/,
        userID: HiveUtils.getUserData()!.id.toString(),
        userName:HiveUtils.getUserData()!.name,
        plugins: [ZegoUIKitSignalingPlugin()],
        config: ZegoCallInvitationConfig(
          endCallWhenInitiatorLeave: true,
          missedCall: ZegoCallInvitationMissedCallConfig(
            enabled: true,
              enableDialBack : true,
          ),
        ),
        invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
          onIncomingCallTimeout: (
              String callID,
              ZegoCallUser caller
              ) {},
          onIncomingMissedCallClicked: (
              String callID,
              ZegoCallUser caller,
              ZegoCallInvitationType callType,
              List<ZegoCallUser> callees,
              String customData,

              /// The default action is to dial back the missed call
              Future<void> Function() defaultAction,
              ) async {
            /// Add your custom logic here.

            await defaultAction.call();
          },

          onIncomingMissedCallDialBackFailed: () {
            /// Add your custom logic here.
          },
        ),
        ringtoneConfig:  ZegoCallRingtoneConfig(
          incomingCallPath: "assets/sounds/ringTone.mp3",
          outgoingCallPath: "assets/sounds/ringTone.mp3",
        ),
        requireConfig: (ZegoCallInvitationData data) {
          var config = (data.invitees.length > 1)
              ? ZegoCallInvitationType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
              : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
              : ZegoCallInvitationType.videoCall == data.type
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
          config.layout = ZegoLayout.gallery(
            addBorderRadiusAndSpacingBetweenView: false,
          );
          return config;
        },
      );
      context.pushAndRemove(Routes.layout);
    } else if (state is SubmitOtpError) {
      AppFunctions.showToast(message: state.error, state: ToastStates.error);
    }
  }

  void _checkActiveButton() {
    if (kDebugMode) {
      print(_controller.text.length);
    }
    if (_controller.text.length == 6) {
      cubit.changeActiveButton(true);
    } else {
      cubit.changeActiveButton(false);
    }
  }
}