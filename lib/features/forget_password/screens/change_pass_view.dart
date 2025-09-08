import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/utils/validator.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/forget_password/bloc/forget_password_cubit.dart';
import 'package:new_fly_easy_new/features/forget_password/widgets/forget_pass_text_field.dart';
import 'package:new_fly_easy_new/features/forget_password/widgets/upper_widget.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class ChangePassView extends StatefulWidget {
  const ChangePassView({Key? key}) : super(key: key);

  @override
  State<ChangePassView> createState() => _ChangePassViewState();
}

class _ChangePassViewState extends State<ChangePassView> {
  ForgetPasswordCubit get cubit => BlocProvider.of(context);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  late String password, confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
           UpperWidget(
              title: LocaleKeys.reset_password.tr(),
              imagePath: AppImages.password,
              subTitle: LocaleKeys.create_new_password.tr()),
          ForgetPassTextField(
              hint: LocaleKeys.enter_your_password.tr(),
              obSecure: true,
              validator: _validatePassword,
              onSave: (value) {
                password = value!;
              },
              controller: passController),
          SizedBox(
            height: 10.h,
          ),
          ForgetPassTextField(
            hint: LocaleKeys.confirm_password.tr(),
            controller: confirmPassController,
            validator: (value) {
              if(value!.isEmpty){
                return LocaleKeys.enter_password_confirmation.tr();
              }else if (value != passController.text) {
                return LocaleKeys.the_value_does_not_match.tr();
              }else {
                return null;
              }
            },
            onSave: (value) {
              confirmPassword = value!;
            },
            obSecure: true,
          ),
          SizedBox(
            height: 20.h,
          ),
          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
            buildWhen: (previous, current) =>
                current is SendNewPassError ||
                current is SendNewPassSuccess ||
                current is SendNewPassLoad,
            builder: (context, state) => CustomButton(
                width: double.infinity,
                onPress: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    cubit.sendNewPassword(newPss: password);
                  }
                },
                buttonType: 1,
                child: state is SendNewPassLoad
                    ? const MyProgress(
                  color: Colors.white,
                )
                    :  ButtonText(title: LocaleKeys.submit.tr())),
          )
        ],
      ),
    );
  }

  String? _validatePassword(String? value) {
    ValidationState validation = Validator.validatePassword(value);
    if (validation == ValidationState.empty) {
      return LocaleKeys.password_can_not_empty.tr();
    } else if (validation == ValidationState.formatting) {
      return LocaleKeys.password_must_8_at_least.tr();
    } else {
      return null;
    }
  }
}
