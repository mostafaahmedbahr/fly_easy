import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/cache/cahce_utils.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/forget_password/bloc/forget_password_cubit.dart';
import 'package:new_fly_easy_new/features/forget_password/widgets/upper_widget.dart';
import 'package:new_fly_easy_new/features/register/widgets/pin_fields.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/features/widgets/inactive_button.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class OtpView extends StatefulWidget {
  const OtpView({Key? key}) : super(key: key);

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  ThemeData get theme=>Theme.of(context);
  ForgetPasswordCubit get cubit => ForgetPasswordCubit.get(context);
  final TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String otp;
  Timer? timer;
  int start = 30;

@override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
           UpperWidget(
              title: LocaleKeys.enter_otp.tr(),
              imagePath: AppImages.email,
              subTitle:
              LocaleKeys.enter_otp_sent.tr()),
          PinCodeFields(
            context: context,
            onSave: (value) {
              otp = value!;
              cubit.otpCode=value;
            },
            controller: controller,
            onChange: (value) {
              _checkActiveButton();
            },
          ),
          SizedBox(
            height: 30.h,
          ),
          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
            buildWhen: (previous, current) =>
                current is ChangeActiveButton ||
                current is SendOtpSuccess ||
                current is SendOtpLoad ||
                current is SendOtpError,
            builder: (context, state) => cubit.isActiveButton
                ? CustomButton(
                    width: double.infinity,
                    onPress: () {
                      formKey.currentState!.save();
                      cubit.sendOtp();
                    },
                    buttonType: 1,
                    child: state is SendOtpLoad
                        ? const MyProgress(
                      color: Colors.white,
                    )
                        :  ButtonText(title: LocaleKeys.reset_password.tr()))
                :  InactiveButton(
                    width: double.infinity,
                    title: ButtonText(title: LocaleKeys.reset_password.tr())),
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text(
                LocaleKeys.did_not_get_otp.tr(),
                style:  TextStyle(
                  color:CacheUtils.isDarkMode()?Colors.white: const Color(0xFF3A4053),
                  fontSize: 15.32,
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w400,
                  height: 0.10,
                ),
              ),
              if(start!=0)
                ...[
                  SizedBox(width: 10.w,),
                  Text('00:$start',style: const TextStyle(
                    color: Color(0xFF3461FD)
                  ),),
                ],
              TextButton(
                  onPressed: () {
                   if(start==0){
                     setState(() {
                       start = 30; // reset the countdown
                       startTimer();
                     });
                     cubit.resendOtp();
                   }
                  },
                  child:  Text(
                    LocaleKeys.resend_otp.tr(),
                    style:  TextStyle(
                      color:start>0?Colors.grey:const Color(0xFF3461FD),
                      fontSize: 15.32,
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.w400,
                      height: 0.10,
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    timer?.cancel();
  }

  /// ////////////////////////////////
/// //////// Helper Methods /////////
/// //////////////////////////////////

  void _checkActiveButton() {
    if (kDebugMode) {
      print(controller.text.length);
    }
    if (controller.text.length == 6) {
      cubit.changeActiveButton(true);
    } else {
      cubit.changeActiveButton(false);
    }
  }

  void startTimer() {
    start=30;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }
}
