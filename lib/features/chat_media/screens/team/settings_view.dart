import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/moderators/moderator_item.dart';
import 'package:new_fly_easy_new/features/chat/models/chat_info/team_chat_info_model.dart';
import 'package:new_fly_easy_new/features/chat_media/bloc/team_chat_media_bloc/chat_media_cubit.dart';
import 'package:new_fly_easy_new/features/widgets/custom_button.dart';
import 'package:new_fly_easy_new/translations/locale_keys.g.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with AutomaticKeepAliveClientMixin {
  ChatMediaCubit get cubit => ChatMediaCubit.get(context);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => cubit.getChannelDetails());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ChatMediaCubit, ChatMediaState>(
      buildWhen: (previous, current) =>
          current is GetDetailsSuccess ||
          current is GetDetailsError ||
          current is GetDetailsLoad,
      builder: (context, state) => state is GetDetailsSuccess
          ? Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.admin.tr(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.poppins),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60.h,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          context.push(Routes.chat,
                              arg: TeamChatInfoModel(
                                id: cubit.channelDetails!.admin.id,
                                image: cubit.channelDetails!.admin.image,
                                name: cubit.channelDetails!.admin.name,
                                isTeam: false,
                              ));
                        },
                        child: MemberItem(
                          member: cubit.channelDetails!.admin,
                          isAdmin: true,
                        ),
                      ),
                      separatorBuilder: (context, index) => 10.w.width,
                      itemCount: 1),
                ),
               if(cubit.moderators.isNotEmpty)
               ...[ SizedBox(
                 height: 20.h,
               ),Padding(padding: EdgeInsets.symmetric(horizontal: 10.w), child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${LocaleKeys.moderator.tr()}(${cubit.moderators.length})',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.poppins),
                      ),
                    ],
                  ),), SizedBox(
                  height: 60.h,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              context.push(Routes.chat,
                                  arg: TeamChatInfoModel(
                                    id: cubit.moderators[index].id,
                                    image: cubit.moderators[index].image,
                                    name: cubit.moderators[index].name,
                                    isTeam: false,
                                  ));
                            },
                            child: MemberItem(
                              member: cubit.moderators[index],
                            ),
                          ),
                      separatorBuilder: (context, index) => 10.w.width,
                      itemCount: cubit.moderators.length),
                ),],
               if(cubit.members.isNotEmpty)
               ...[
                 SizedBox(
                   height: 20.h,
                 ),
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Row(
                    children: [
                      Text(
                        '${LocaleKeys.members.tr()}(${cubit.members.length})',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.poppins),
                      ),
                      const Spacer(),
                      // TextButton(
                      //     onPressed: () {},
                      //     child: Text(
                      //       'Manage',
                      //       style: Theme.of(context).textTheme.titleSmall,
                      //     ))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      // scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            context.push(Routes.chat,
                                arg: TeamChatInfoModel(
                                  id: cubit.members[index].id,
                                  image: cubit.members[index].image,
                                  name: cubit.members[index].name,
                                  isTeam: false,
                                ));
                          },
                          child: MemberItem(
                              member: cubit.members[index],
                              isModerator: false)),
                      separatorBuilder: (context, index) => 15.h.height,
                      itemCount: cubit.members.length),
                ),],
                Visibility(
                  visible: cubit.channelDetails!.memberType != 2,
                  replacement: const SizedBox.shrink(),
                  child: Container(
                    color: Theme.of(context).cardColor,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: BlocBuilder<ChatMediaCubit, ChatMediaState>(
                      buildWhen: (previous, current) =>
                          current is LeaveTeamLoading ||
                          current is LeaveTeamSuccess ||
                          current is LeaveTeamError,
                      builder: (context, state) => CustomButton(
                          width: context.width * .5,
                          onPress: _onLeaveButtonPressed,
                          buttonType: 1,
                          child: state is LeaveTeamLoading
                              ? const MyProgress(
                                  color: Colors.white,
                                )
                              : ButtonText(title: LocaleKeys.leave.tr())),
                    ),
                  ),
                )
              ],
            )
          : const MyProgress(),
    );
  }

  void _onLeaveButtonPressed() {
    cubit.leaveTeam();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
