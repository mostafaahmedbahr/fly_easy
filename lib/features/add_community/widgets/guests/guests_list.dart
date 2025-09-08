import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/app_extensions.dart';
import 'package:new_fly_easy_new/features/add_community/bloc/add_channel_cubit.dart';
import 'package:new_fly_easy_new/features/add_community/widgets/moderators/moderator_item.dart';

class GuestsList extends StatelessWidget {
  const GuestsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddChannelCubit cubit = AddChannelCubit.get(context);
    return BlocBuilder<AddChannelCubit, AddChannelState>(
      buildWhen: (previous, current) => current is AddGuests,
      builder: (context, state) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w,),
        child: ListView.separated(
          // scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.w,),
          itemBuilder: (context, index) =>
              MemberItem(member: cubit.guests[index],isModerator: false),
          separatorBuilder: (context, index) => 15.h.height,
          itemCount: AddChannelCubit.get(context).guests.length,
        ),
      ),
    );
  }
}

// Align(
// alignment: Alignment.centerRight,
// child: AddMemberButton(
// onTab: () {
// sl<AppRouter>().navigatorKey.currentState!.pushNamed(
// Routes.inviteMembers,
// arguments: InviteIdentifier(
// addChannelCubit: cubit, isModeratorSelection: false));
// },
// ),
// ),

