import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/images.dart';
import 'package:new_fly_easy_new/core/widgets/empty_widget.dart';
import 'package:new_fly_easy_new/core/widgets/error_widget.dart';
import 'package:new_fly_easy_new/core/widgets/my_progress.dart';
import 'package:new_fly_easy_new/features/forward_messages/bloc/forward_message_cubit.dart';
import 'package:new_fly_easy_new/features/forward_messages/widgets/forward_member_widget.dart';

import '../../../app/app_bloc/app_cubit.dart';
import '../../../core/utils/phone_utils.dart';

class ForwardMembersList extends StatelessWidget {
  const ForwardMembersList({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ForwardMessageCubit.get(context);
    final globalCubit = GlobalAppCubit.get(context);

    return BlocBuilder<ForwardMessageCubit, ForwardMessageState>(
      buildWhen: (previous, current) =>
      current is GetAvailableMembersLoad ||
          current is GetAvailableMembersSuccess ||
          current is GetAvailableMembersError,
      builder: (context, state) => state is GetAvailableMembersLoad
          ? const MyProgress()
          : state is GetAvailableMembersError
          ? CustomErrorWidget(message: state.error)
          : cubit.members.isEmpty
          ? const EmptyWidget(
        text: '',
        image: AppImages.emptyTeams,
      )
          : Expanded(
        child: ListView.separated(
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
            bottom: 30.h,
          ),
          separatorBuilder: (_, __) =>
              SizedBox(height: 15.h),
          itemCount: cubit.members.length,
          itemBuilder: (context, index) {
            final member = cubit.members[index];

            final contact =
            PhoneUtils.findContactByPhoneSync(
              member.phone,
              globalCubit.allContacts,
            );

            return ForwardMemberWidget(
              member: member,
              contact: contact,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

