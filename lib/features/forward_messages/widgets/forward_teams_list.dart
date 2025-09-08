import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/error_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/forward_messages/bloc/forward_message_cubit.dart';
import 'package:new_fly_easy_new/features/forward_messages/widgets/forward_team_widget.dart';

class ForwardTeamsList extends StatelessWidget {
  const ForwardTeamsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ForwardMessageCubit cubit = ForwardMessageCubit.get(context);
    return BlocBuilder<ForwardMessageCubit, ForwardMessageState>(
      buildWhen: (previous, current) =>
          current is GetAvailableTeamsError ||
          current is GetAvailableTeamsLoad ||
          current is GetAvailableTeamsSuccess,
      builder: (context, state) => state is GetAvailableTeamsLoad
          ? const MyProgress()
          : state is GetAvailableTeamsError
              ? CustomErrorWidget(message: state.error)
              : cubit.myTeams.isEmpty
                  ? const EmptyWidget(text: '', image: AppImages.emptyTeams)
                  : Expanded(
                      child: ListView.separated(
                          padding: EdgeInsets.only(
                            left: 15.w,
                            right: 15.w,
                            bottom: 30.h,
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                                height: 15.h,
                              ),
                          itemBuilder: (context, index) =>
                              ForwardTeamWidget(team: cubit.myTeams[index]),
                          itemCount: cubit.myTeams.length),
                    ),
    );
  }
}
