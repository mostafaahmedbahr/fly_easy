import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/utils/validator.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/register/bloc/register_cubit.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/features/widgets/custom_text_field.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:iconly/iconly.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ThemeData get themeData => Theme.of(context);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String email, name, password, phone, countryCode,workId,company;

  @override
  void initState() {
    super.initState();
    countryCode = '+20';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: _blocListener,
      child: WillPopScope(
        onWillPop: () async => _backPressed(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          AppImages.upperSignup,
                          fit: BoxFit.cover,
                        )),
                    30.h.height,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        children: [
                          Text(
                            LocaleKeys.create_account.tr(),
                            style: themeData.textTheme.headlineLarge!
                                .copyWith(fontSize: 40.sp),
                          ),
                          30.h.height,
                          CustomTextField(
                            hint: LocaleKeys.enter_your_user_name.tr(),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: AppColors.textFieldIconColor,
                            ),
                            validator: _validateUserName,
                            onSave: (value) {
                              name = value!;
                            },
                          ),
                          20.h.height,
                          // LanguagesDropdown(
                          //     value: language,
                          //     hint: LocaleKeys.choose_your_language.tr(),
                          //     onChanged: (value) {
                          //       language = value;
                          //     },
                          //     items: _getLanguages(languages)),
                          // 20.h.height,
                          CustomTextField(
                            hint: LocaleKeys.enter_your_email.tr(),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: AppColors.textFieldIconColor,
                            ),
                            validator: _validateEmail,
                            onSave: (value) {
                              email = value!;
                            },
                          ),
                          20.h.height,
                          CustomTextField(
                            hint: LocaleKeys.enter_your_phone.tr(),
                            inputType: TextInputType.phone,
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: AppColors.textFieldIconColor,
                            ),
                            suffix: CountryCodePicker(
                              onChanged: (value) {
                                countryCode = value.dialCode!;
                              },
                              initialSelection: 'EG',
                              favorite: const ['+20', 'EG'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                            validator: _validatePhone,
                            onSave: (value) {
                              phone = value!;
                            },
                          ),
                          20.h.height,
                          CustomTextField(
                            hint: LocaleKeys.enter_your_company.tr(),
                            prefixIcon: const Icon(
                              IconlyBold.bag,
                              color: AppColors.textFieldIconColor,
                            ),
                            onSave: (value) {
                              company = value!;
                            },
                          ),
                          20.h.height,
                          CustomTextField(
                            hint: LocaleKeys.enter_your_work_id.tr(),
                            prefixIcon: const Icon(
                              IconlyBold.work,
                              color: AppColors.textFieldIconColor,
                            ),
                            onSave: (value) {
                              workId = value!;
                            },
                          ),
                          20.h.height,
                          CustomTextField(
                            hint: LocaleKeys.enter_your_password.tr(),
                            obSecure: true,
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: AppColors.textFieldIconColor,
                            ),
                            validator: _validatePassword,
                            onSave: (value) {
                              password = value!;
                            },
                          ),
                          25.h.height,
                          BlocBuilder<RegisterCubit, RegisterState>(
                            builder: (context, state) => CustomButton(
                                onPress: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    await RegisterCubit.get(context).register(
                                      email: email,
                                      name: name,
                                      password: password,
                                      phone: phone,
                                      countryCode: countryCode,
                                      workId: workId,
                                      company: company,
                                    );
                                  }
                                },
                                width: double.infinity,
                                buttonType: 1,
                                child: state is RegisterLoading
                                    ? const MyProgress(
                                        color: Colors.white,
                                      )
                                    : ButtonText(
                                        title: LocaleKeys.sign_up.tr())),
                          ),
                          10.h.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.already_have_account.tr(),
                                style: themeData.textTheme.labelSmall!
                                    .copyWith(fontFamily: AppFonts.lato),
                              ),
                              TextButton(
                                  style: const ButtonStyle(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero)),
                                  onPressed: () {
                                    context.pushAndRemove(Routes.login);
                                  },
                                  child: Text(
                                    LocaleKeys.login.tr(),
                                    style: themeData.textTheme.labelSmall!
                                        .copyWith(
                                            fontFamily: AppFonts.poppins,
                                            color:
                                                AppColors.lightSecondaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                AppColors.lightSecondaryColor,
                                            decorationThickness: 1.5),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SvgPicture.asset(
                        AppImages.lowerLogin,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ///////////////// Helper Methods /////////////////////////////////////////
  /// /////////////////////////////////////////////////////////////////////////
  /// /////////////////////////////////////////////////////////////////////////

  void _blocListener(BuildContext context, RegisterState state) {
    if (state is RegisterError) {
      AppFunctions.showToast(message: state.error, state: ToastStates.error);
    } else if (state is RegisterSuccess) {
      AppFunctions.showToast(
          message: LocaleKeys.register_success.tr(),
          state: ToastStates.success);
      context.push(Routes.otp, arg: email);
    }
  }

  String? _validateEmail(String? value) {
    ValidationState validation = Validator.validateEmail(value);
    if (validation == ValidationState.empty) {
      return LocaleKeys.email_can_not_empty.tr();
    } else if (validation == ValidationState.formatting) {
      return LocaleKeys.enter_valid_email.tr();
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    ValidationState validation = Validator.validatePassword(value);
    if (validation == ValidationState.empty) {
      return LocaleKeys.password_can_not_empty.tr();
    } else if (validation == ValidationState.count) {
      return LocaleKeys.password_must_8_at_least.tr();
    } else if(validation==ValidationState.formatting){
      return 'small and capital letters,numbers and symbols';
    }else {
      return null;
    }
  }
  String? _validateUserName(String? value) {
    if (Validator.validateText(value) == ValidationState.empty) {
      return LocaleKeys.user_name_can_not_empty.tr();
    } else {
      return null;
    }
  }

  String? _validatePhone(String? value) {
    if (Validator.validateText(value) == ValidationState.empty) {
      return LocaleKeys.phone_can_not_empty.tr();
    } else {
      return null;
    }
  }

  Future<bool> _backPressed() async {
    context.pushAndRemove(Routes.login);
    return Future<bool>.value(true);
  }

  List<DropdownMenuItem<String>> _getLanguages(List<String> list) {
    return list
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                    fontSize: 16.sp, fontWeight: FontWeight.w600, height: 1),
              ),
            ))
        .toList();
  }

  final List<String> languages = [
    LocaleKeys.arabic.tr(),
    LocaleKeys.english.tr(),
    LocaleKeys.french.tr()
  ];
}
