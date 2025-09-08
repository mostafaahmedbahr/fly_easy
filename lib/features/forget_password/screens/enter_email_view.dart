import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/forget_password/bloc/forget_password_cubit.dart';
import 'package:new_fly_easy_new/features/forget_password/widgets/forget_pass_text_field.dart';
import 'package:new_fly_easy_new/features/forget_password/widgets/upper_widget.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class EnterEmailView extends StatefulWidget {
  const EnterEmailView({Key? key}) : super(key: key);

  @override
  State<EnterEmailView> createState() => _EnterEmailViewState();
}

class _EnterEmailViewState extends State<EnterEmailView> {
  ForgetPasswordCubit get cubit => ForgetPasswordCubit.get(context);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _emailController.text = cubit.email ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
             UpperWidget(
                title: LocaleKeys.forget_password.tr(),
                imagePath: AppImages.email,
                subTitle: LocaleKeys.please_enter_email_to_get_otp.tr()),
            SizedBox(
              height: 20.h,
            ),
            ForgetPassTextField(
              hint: LocaleKeys.email.tr(),
              controller: _emailController,
              validator: (value) {
                if(value!.isEmpty){
                  return LocaleKeys.please_enter_email.tr();
                }else {
                  return null;
                }
              },
              onSave: (value) {
                cubit.email=value;
              },
            ),
            SizedBox(
              height: 30.h,
            ),
            BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
              buildWhen: (previous, current) =>
                  current is SendEmailSuccess ||
                  current is SendEmailLoad ||
                  current is SendNewPassError,
              builder: (context, state) => CustomButton(
                  width: double.infinity,
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      cubit.sendOtpViaEmail();
                    }
                  },
                  buttonType: 1,
                  child: state is SendEmailLoad
                      ? const MyProgress(
                    color: Colors.white,
                  )
                      :  ButtonText(title: LocaleKeys.continue_.tr())),
            )
          ],
        ));
  }
}
