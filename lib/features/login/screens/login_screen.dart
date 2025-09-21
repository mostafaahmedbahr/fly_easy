import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/utils/validator.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/login/bloc/login_cubit.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/features/widgets/custom_text_field.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import "package:zego_uikit/src/components/audio_video_container/layout.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ThemeData get themeData => Theme.of(context);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String email, password;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          AppFunctions.showToast(
              message: state.error, state: ToastStates.error);
        } else if (state is LoginSuccess) {
          AppFunctions.showToast(
              message: LocaleKeys.login_success.tr(), state: ToastStates.
              success);
          context.pushAndRemove(Routes.layout);
        }else if (state is EmailNotVerified) {
              context.push(Routes.otp, arg: email);
            }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: SvgPicture.asset(
                      AppImages.upperLogin,
                      fit: BoxFit.cover,
                    )),
                20.h.height,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.hello.tr(),
                          style: themeData.textTheme.headlineLarge!
                              .copyWith(fontSize: 70.sp),
                        ),
                        15.h.height,
                        Text(
                          LocaleKeys.sign_in_to_account.tr(),
                          style: TextStyle(
                              color: AppColors.loginSubtitle,
                              fontFamily: AppFonts.lato,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        30.h.height,
                        CustomTextField(
                          hint: LocaleKeys.enter_your_email.tr(),
                          prefixIcon: const Icon(
                            AppIcons.user,
                            color: AppColors.textFieldIconColor,
                          ),
                          validator: _validateUserName,
                          onSave: (value) {
                            email = value!;
                          },
                        ),
                        20.h.height,
                        CustomTextField(
                          hint: LocaleKeys.enter_your_password.tr(),
                          prefixIcon: const Icon(
                            AppIcons.lock,
                            color: AppColors.textFieldIconColor,
                          ),
                          obSecure: true,
                          validator: _validatePassword,
                          onSave: (value) {
                            password = value!;
                          },
                        ),
                        10.h.height,
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () =>
                                context.push(Routes.forgetPassRoute),
                            child: Text(
                              LocaleKeys.forget_your_password.tr(),
                              style: TextStyle(
                                  color: AppColors.bodyMedium,
                                  fontFamily: AppFonts.lato,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        20.h.height,
                        BlocConsumer<LoginCubit, LoginState>(
                          listener: (context,state){
                            if(state is LoginSuccess){
                              ZegoUIKitPrebuiltCallInvitationService().init(
                                // androidNotificationConfig: ZegoAndroidNotificationConfig(
                                //   sound: "zego_incoming",
                                // ),
                                appID:  1812799240/*input your AppID*/,
                                appSign: 'f053c726dd8a0d08b2e7183517d8b26d3e7626193c0a72906f722ddd2339c82a' /*input your AppSign*/,
                                userID: state.userId,
                                userName: state.userName,
                                // controller: zegoUIKitPrebuiltCallController,
                                plugins: [ZegoUIKitSignalingPlugin(),],
                                // notifyWhenAppRunningInBackgroundOrQuit: true,
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
                                  // Modify your custom configurations here.
                                  config.layout = ZegoLayout.gallery(
                                    addBorderRadiusAndSpacingBetweenView: false,
                                  );
                                  return config;
                                },
                              );
                            }
                          },
                          builder: (context, state) => CustomButton(
                              onPress: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  await LoginCubit.get(context)
                                      .login(email: email, password: password);
                                }
                              },
                              width: double.infinity,
                              buttonType: 1,
                              child: state is LoginLoading
                                  ? const MyProgress(
                                color: Colors.white,
                              )
                                  :  ButtonText(title:LocaleKeys.log_in.tr())),
                        ),
                        10.h.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.do_not_have_account.tr(),
                              style: themeData.textTheme.labelSmall!
                                  .copyWith(fontFamily: AppFonts.lato),
                            ),
                            TextButton(
                                style: const ButtonStyle(
                                    alignment: AlignmentDirectional.centerStart,
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.zero)),
                                onPressed: () {
                                  context.push(Routes.register);
                                },
                                child: Text(
                                  LocaleKeys.create.tr(),
                                  style: themeData.textTheme.labelSmall!
                                      .copyWith(
                                      fontFamily: AppFonts.poppins,
                                      color: AppColors.lightSecondaryColor,
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                      AppColors.lightSecondaryColor,
                                      decorationThickness: 1.5),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SvgPicture.asset(
                    AppImages.lowerLogin,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// /////////////////////////////////////////////////////
  /// /////////////// Helper Methods //////////////////////
  /// ////////////////////////////////////////////////////

  // void _blocListener(BuildContext context, LoginState state) {
  //   if (state is LoginError) {
  //     AppFunctions.showToast(
  //         message: state.error, state: ToastStates.error);
  //   } else if (state is LoginSuccess) {
  //     ZegoUIKitPrebuiltCallInvitationService().init(
  //       androidNotificationConfig: ZegoAndroidNotificationConfig(
  //         sound: "zego_incoming",
  //       ),
  //       appID: 905533630 /*input your AppID*/,
  //       appSign: '0b7f22ef2f82ab4cba6beb3a5fe76c9b3590047110a96744b0578e29c2ed7372' /*input your AppSign*/,
  //       userID: state.userId,
  //       userName: state.userName,
  //       controller: zegoUIKitPrebuiltCallController,
  //       // controller: zegoUIKitPrebuiltCallController,
  //       plugins: [ZegoUIKitSignalingPlugin(),],
  //       notifyWhenAppRunningInBackgroundOrQuit: true,
  //       ringtoneConfig: const ZegoRingtoneConfig(
  //         incomingCallPath: "assets/sounds/ringTone.mp3",
  //         outgoingCallPath: "assets/sounds/ringTone.mp3",
  //       ),
  //       requireConfig: (ZegoCallInvitationData data) {
  //         var config = (data.invitees.length > 1)
  //             ? ZegoCallType.videoCall == data.type
  //             ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
  //             : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
  //             : ZegoCallType.videoCall == data.type
  //             ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
  //             : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
  //         // Modify your custom configurations here.
  //         config.layout = ZegoLayout.gallery(
  //           addBorderRadiusAndSpacingBetweenView: false,
  //         );
  //         return config;
  //       },
  //     );
  //     AppFunctions.showToast(
  //         message: LocaleKeys.login_success.tr(), state: ToastStates.
  //     success);
  //     context.pushAndRemove(Routes.layout);
  //   } else if (state is EmailNotVerified) {
  //     context.push(Routes.otp, arg: email);
  //   }
  // }

  String? _validatePassword(String? value) {
    ValidationState validation = Validator.validatePassword(value);
    if (validation == ValidationState.empty) {
      return LocaleKeys.password_can_not_empty.tr();
    } else {
      return null;
    }
  }

  String? _validateUserName(String? value) {
    if (Validator.validateText(value) == ValidationState.empty) {
      return LocaleKeys.email_can_not_empty.tr();
    } else {
      return null;
    }
  }
}
