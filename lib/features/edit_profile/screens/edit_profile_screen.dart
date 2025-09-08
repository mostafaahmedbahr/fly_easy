import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/hive/hive_utils.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/app_icons.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/validator.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/edit_profile/bloc/edit_profile_cubit.dart';
import 'package:new_fly_easy_new/features/profile/bloc/profile_cubit.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/features/widgets/custom_text_field.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';
import 'package:iconly/iconly.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.profileCubit})
      : super(key: key);
  final ProfileCubit profileCubit;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileCubit get cubit => EditProfileCubit.get(context);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController workIdController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  late String name, phone,countryCode,workId,company;

  @override
  void initState() {
    super.initState();
    nameController.text = HiveUtils.getUserData()!.name;
    phoneController.text = HiveUtils.getUserData()!.phone;
    workIdController.text=HiveUtils.getUserData()!.workId??'';
    companyController.text=HiveUtils.getUserData()!.company??'';
    countryCode=HiveUtils.getUserData()!.countryCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: BlocListener<EditProfileCubit, EditProfileState>(
        listener:_blocListener,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  hint: LocaleKeys.enter_your_name.tr(),
                  prefixIcon: const Icon(
                    AppIcons.user,
                    color: AppColors.textFieldIconColor,
                  ),
                  controller: nameController,
                  onSave: (value) {
                    name = value!;
                  },
                  validator: _validateUserName,
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                  hint: LocaleKeys.enter_your_company.tr(),
                  controller: companyController,
                  prefixIcon: const Icon(
                    IconlyBold.bag,
                    color: AppColors.textFieldIconColor,
                  ),
                  onSave: (value) {
                    company = value!;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                  hint: LocaleKeys.enter_your_work_id.tr(),
                  controller: workIdController,
                  prefixIcon: const Icon(
                    IconlyBold.work,
                    color: AppColors.textFieldIconColor,
                  ),
                  onSave: (value) {
                    workId = value!;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                  hint: LocaleKeys.enter_your_phone.tr(),
                  controller: phoneController,
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
                  onSave: (value) {
                    phone = value!;
                  },
                  validator: _validatePhone,
                ),
                SizedBox(
                  height: 80.h,
                ),
                BlocBuilder<EditProfileCubit, EditProfileState>(
                  buildWhen: (previous, current) =>
                      current is EditProfileSuccess ||
                      current is EditProfileError ||
                      current is EditProfileLoad,
                  builder: (context, state) => CustomButton(
                      width: context.width * .5,
                      onPress: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          await cubit.updateProfile(name: name, phone: phone,countryCode: countryCode,workId: workId,company: company);
                        }
                      },
                      buttonType: 1,
                      child: state is EditProfileLoad
                          ? const MyProgress(
                        color: Colors.white,
                      )
                          :  ButtonText(title: LocaleKeys.update.tr())),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    workIdController.dispose();
  }

  /// /////////////////////////////////////////
  /// ///////////// Helper Widgets ////////////
  /// ////////////////////////////////////////
  AppBar _appBar()=>AppBar(
    title:  Text(LocaleKeys.edit_profile.tr()),
    centerTitle: true,
    leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios)),
  );

  /// /////////////////////////////////////////////////
  /// //////////////// Helper Methods ////////////////
  /// ///////////////////////////////////////////////

  void _blocListener(BuildContext context,EditProfileState state){
    if (state is EditProfileError) {
      AppFunctions.showToast(
          message: state.error, state: ToastStates.error);
    } else if (state is EditProfileSuccess) {
      AppFunctions.showToast(
          message: LocaleKeys.updated_success.tr(), state: ToastStates.success);
      widget.profileCubit.refreshUserData();
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
}
