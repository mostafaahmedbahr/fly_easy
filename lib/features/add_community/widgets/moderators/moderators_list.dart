import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/injection/di_container.dart';
import 'package:new_fly_easy_new/core/routing/router.dart';
import 'package:new_fly_easy_new/core/routing/routes.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';
import 'package:new_fly_easy_new/features/add_community/models/invite_indentifier.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/add_member_button.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/moderators/moderator_item.dart';

class ModeratorsList extends StatelessWidget {
  const ModeratorsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddChannelCubit cubit=AddChannelCubit.get(context);
    return BlocBuilder<AddChannelCubit,AddChannelState>(
      buildWhen: (previous, current) => current is AddModerators,
      builder: (context, state) =>  ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          itemBuilder: (context, index) => MemberItem(
                member: AddChannelCubit.get(context)
                    .moderators[index],
              ),
          separatorBuilder: (context, index) => 10.w.width,
          itemCount: AddChannelCubit.get(context)
              .moderators.length),
    );
  }
}
