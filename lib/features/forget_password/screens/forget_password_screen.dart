import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/features/forget_password/bloc/forget_password_cubit.dart';
import 'package:new_fly_easy_new/features/forget_password/widgets/progress_widget.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ForgetPasswordCubit cubit = ForgetPasswordCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              if (cubit.currentViewIndex != 0) {
                cubit.changeCurrentView(cubit.currentViewIndex - 1);
              } else {
                context.pop();
              }
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is SendEmailSuccess) {
            cubit.changeCurrentView(1);
          } else if (state is SendOtpSuccess) {
            cubit.changeCurrentView(2);
          } else if (state is SendNewPassSuccess) {
            AppFunctions.showToast(
                message: LocaleKeys.password_changed_success.tr(),
                state: ToastStates.error);
            context.pop();
          } else if (state is ErrorState) {
            AppFunctions.showToast(
                message: state.error, state: ToastStates.error);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          child: BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
              buildWhen: (previous, current) => current is ChangeCurrentView,
              builder: (context, state) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProgressWidget(
                            isActive: cubit.currentViewIndex == 0,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          ProgressWidget(
                            isActive: cubit.currentViewIndex == 1,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          ProgressWidget(
                            isActive: cubit.currentViewIndex == 2,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      cubit.views[cubit.currentViewIndex]
                    ],
                  )),
        ),
      ),
    );
  }
}
