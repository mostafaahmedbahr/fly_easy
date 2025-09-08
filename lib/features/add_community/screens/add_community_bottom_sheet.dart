import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/app/app_bloc/app_cubit.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/app_functions.dart';
import 'package:new_fly_easy_new/core/utils/enums.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/error_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';
import 'package:new_fly_easy_new/features/add_community/models/invite_indentifier.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/create_button.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/image/image_widget.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/member_moderator_title.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/name_form_field.dart';
import 'package:new_fly_easy_new/features/profile/widgets/charge_counter.dart';
import 'package:new_fly_easy_new/features/profile/widgets/charge_counter_title.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class AddCommunitySheet extends StatefulWidget {
  const AddCommunitySheet(
      {Key? key, this.parentId, required this.level, this.isEdit = false})
      : super(key: key);
  final int? parentId;
  final bool isEdit;
  final int level;

  @override
  State<AddCommunitySheet> createState() => _AddCommunitySheetState();
}

class _AddCommunitySheetState extends State<AddCommunitySheet> {
  ThemeData get themeData => Theme.of(context);
  AddChannelCubit get cubit => AddChannelCubit.get(context);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    if (widget.isEdit) {
      Future.microtask(() => cubit.getChannelDetails(widget.parentId!));
    }
    cubit.level = widget.level;
    nameController.text = cubit.channelName ?? '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddChannelCubit, AddChannelState>(
      listener: _listenerFunction,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
              color: themeData.cardColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.r),
                  topLeft: Radius.circular(40.r))),
          child: BlocBuilder<AddChannelCubit, AddChannelState>(
            buildWhen: (previous, current) =>
                current is GetChannelDetailsLoad ||
                current is GetChannelDetailsSuccess ||
                current is GetChannelDetailsError,
            builder: (context, state) {
              if (state is GetChannelDetailsLoad) {
                return const MyProgress();
              } else if (state is GetChannelDetailsError) {
                return CustomErrorWidget(message: state.error);
              } else {
                return Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const ImageWidget(),
                      25.h.height,
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getTextFieldTitle(),
                                style: themeData.textTheme.titleLarge!
                                    .copyWith(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFonts.roboto),
                              ),
                              NameFormField(
                                controller: nameController,
                                validator: _validateTeamName,
                                onSave: (value) {
                                  cubit.channelName = value;
                                },
                              ),
                              MemberModeratorTitle(title: LocaleKeys.moderator.tr(), onAddPressed:  () {
                                sl<AppRouter>()
                                    .navigatorKey
                                    .currentState!
                                    .pushNamed(Routes.inviteMembers,
                                    arguments: InviteIdentifier(
                                        addChannelCubit: cubit,
                                        isModeratorSelection:
                                        true));
                              }),
                              8.h.height,
                              // SizedBox(
                              //   height: 45.h,
                              //   child: const ModeratorsList(),
                              // ),
                              MemberModeratorTitle(title: LocaleKeys.member.tr(), onAddPressed: () {
                            context.push(Routes.inviteMembers,
                                arg: InviteIdentifier(
                                    addChannelCubit: cubit,
                                    isModeratorSelection: false));
                          }),
                              // 8.h.height,
                              // const GuestsList(),
                              // 20.h.height,
                              15.h.height,
                              ChargeCounterTitle(onUpgradePressed: _onUpgradePressed),
                              const ChargeCounter(),
                            ],
                          ),
                        ),
                      ),
                      CreateButton(
                        onPress: _onCreateButtonPressed,
                        title: widget.isEdit
                            ? LocaleKeys.save.tr()
                            : LocaleKeys.create.tr(),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  /// /////////////////////////////////
  /// ////////// Helper Methods ////////
  /// /////////////////////////////////

  void _onCreateButtonPressed() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (widget.isEdit) {
        cubit.updateChannel(
          parentId: widget.parentId,
        );
      } else {
        cubit.createChannel(parentId: widget.parentId);
      }
    }
  }

  String? _validateTeamName(String? value) {
    if (value!.isEmpty) {
      return LocaleKeys.channel_name_required.tr();
    } else {
      return null;
    }
  }

  void _listenerFunction(BuildContext context, AddChannelState state) {
    if (state is CreateChannelError) {
      AppFunctions.showToast(message: state.error, state: ToastStates.error);
    } else if (state is CreateChannelSuccess) {
      GlobalAppCubit.get(context).refreshChannelsAfterAdding();
      context.pop();
    } else if (state is GetChannelDetailsSuccess) {
      nameController.text = cubit.channelDetails!.name;
    }
  }

  String _getTextFieldTitle() {
    if (widget.level == 1) {
      return LocaleKeys.channel_name.tr();
    } else if (widget.level == 2) {
      return LocaleKeys.community_name.tr();
    } else {
      return LocaleKeys.sub_community_name.tr();
    }
  }

  void _onUpgradePressed() {
    context.pop();
    context.push(Routes.plans);
  }
}
